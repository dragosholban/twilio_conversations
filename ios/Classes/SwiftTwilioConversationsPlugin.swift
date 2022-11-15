import Flutter
import UIKit
import TwilioConversationsClient

public class SwiftTwilioConversationsPlugin: NSObject, FlutterPlugin, TwilioConversationsClientDelegate {
    private var client: TwilioConversationsClient?
    private var pushToken: Data?
    private static var conversationsStreamHandler: TwilioConversationsStreamHandler = TwilioConversationsStreamHandler()
    public static var conversationListeners: [String: ConversationListener] = [:]
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "twilio_conversations", binaryMessenger: registrar.messenger())
        let myEventChannel = FlutterEventChannel(name: "twilio_conversations_stream", binaryMessenger: registrar.messenger())
        myEventChannel.setStreamHandler(conversationsStreamHandler)
        
        let instance = SwiftTwilioConversationsPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        registrar.addApplicationDelegate(instance)
    }
    
    public static func addToSink(data: Any) {
        SwiftTwilioConversationsPlugin.conversationsStreamHandler.sink?(data)
    }
    
    public func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            pushToken = deviceToken;
        }
    
    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError
        error: Error) {
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "initClient":
            let arguments = call.arguments as! [String: Any]
            let token = arguments["token"] as! String
            
            client?.shutdown()
            SwiftTwilioConversationsPlugin.conversationListeners.removeAll()
            // Set up Twilio Conversations client
            TwilioConversationsClient.conversationsClient(withToken: token,
                                                          properties: nil,
                                                          delegate: self) { (initResult, client) in
                self.client = client
                if (initResult.isSuccessful) {
                    SwiftTwilioConversationsPlugin.addToSink(data: [
                        "event": "clientCreated",
                        "identity": self.client?.user?.identity,
                    ])
                }
                result(initResult.isSuccessful)
            }
        case "shutdown":
            client?.shutdown()
            SwiftTwilioConversationsPlugin.conversationListeners.removeAll()
            result(true)
        case "myConversations":
            var conversations: [[String: Any?]] = []
            
            for  conversation in client?.myConversations() ?? [] {
                conversations.append(["sid": conversation.sid, "friendlyName": conversation.friendlyName, "lastMessageDate": conversation.lastMessageDate?.ISO8601Format(), "lastMessageIndex": conversation.lastMessageIndex])
                
                if !SwiftTwilioConversationsPlugin.conversationListeners.keys.contains(conversation.sid!) {
                    NSLog("setupConversationListener => conversation: \(String(describing: conversation.sid))")
                    SwiftTwilioConversationsPlugin.conversationListeners[conversation.sid!] = ConversationListener(conversation.sid!)
                    conversation.delegate = SwiftTwilioConversationsPlugin.conversationListeners[conversation.sid!]
                }
            }
            
            result(conversations)
        case "getConversation":
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String
            
            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    var jsonData: Data? = nil
                    if (conversation?.attributes()?.isDictionary ?? false) {
                        do {
                            jsonData = try JSONSerialization.data(withJSONObject: conversation?.attributes()?.dictionary, options: .prettyPrinted)
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                    
                    result(["sid": conversation?.sid,
                            "friendlyName": conversation?.friendlyName,
                            "lastMessageDate": conversation?.lastMessageDate?.ISO8601Format(),
                            "lastMessageIndex": conversation?.lastMessageIndex,
                            "attributes": jsonData != nil ? String(data: jsonData!,
                                                                   encoding: String.Encoding.ascii) : nil
                           ])
                } else {
                    result(nil)
                }
            }
        case "getMessageByIndex":
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String
            let index = arguments["index"] as! Int
            
            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    if (conversation?.synchronizationStatus == TCHConversationSynchronizationStatus.all) {
                        conversation?.message(withIndex: NSNumber(value: index)) { (r, message) in
                            if(r.isSuccessful) {
                                var returnMedia: [[String: Any?]] = []
                                
                                for media in message?.attachedMedia ?? [] {
                                    returnMedia.append([
                                        "mediaSid": media.sid,
                                    ])
                                }
                                
                                var jsonData: Data? = nil
                                if (message?.attributes()?.isDictionary ?? false) {
                                    do {
                                        jsonData = try JSONSerialization.data(withJSONObject: message?.attributes()?.dictionary, options: .prettyPrinted)
                                    } catch let error as NSError {
                                        print(error)
                                    }
                                }
                                
                                result([
                                    "messageSid": message?.sid,
                                    "messageBody": message?.body,
                                    "messageIndex": message?.index,
                                    "participantIdentity": message?.participant?.identity,
                                    "date": message?.dateCreated,
                                    "hasMedia": message?.attachedMedia.count ?? 0 > 0,
                                    "attachedMedia": returnMedia,
                                    "attributes": jsonData != nil ? String(data: jsonData!,
                                                                           encoding: String.Encoding.ascii) : nil
                                ])
                            } else {
                                result(nil)
                            }
                        }
                    } else {
                        result(nil)
                
                    }
                } else {
                    result(nil)
                }
            }
        case "getMessagesCount" :
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String
            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    conversation?.getMessagesCount() { (r, count) in
                        if(r.isSuccessful) {
                            result(count)
                        } else {
                            result(nil)
                        }
                    }
                } else {
                    result(nil)
                }
            }
        case "getUnreadMessagesCount" :
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String
            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    conversation?.getUnreadMessagesCount() { (r, count) in
                        if(r.isSuccessful) {
                            result(count)
                        } else {
                            result(nil)
                        }
                    }
                } else {
                    result(nil)
                }
            }
        case "getConversationUserIsOnline":
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String

            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    if (conversation?.synchronizationStatus == TCHConversationSynchronizationStatus.all) {
                        conversation?.participants().forEach() { (participant) in
                            if (participant.identity != self.client?.user?.identity) {
                                participant.subscribedUser() { (r, user) in
                                    if (r.isSuccessful) {
                                        result(user?.isOnline());
                                    } else {
                                        result(nil)
                                    }
                                }
                            }
                        }
                    } else {
                        result(nil)
                    }
                } else {
                    result(nil)
                }
            }
            
        case "setAllMessagesRead" :
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String
            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    conversation?.setAllMessagesReadWithCompletion() { (r, count) in
                        if(r.isSuccessful) {
                            result(count)
                        } else {
                            result(nil)
                        }
                    }
                } else {
                    result(nil)
                }
            }
        case "getMessages":
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String
            
            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    conversation?.getLastMessages(withCount: 100) { (r, messages) in
                        if(r.isSuccessful) {
                            var returnMessages: [[String: Any?]] = []
                            
                            for message in messages ?? [] {
                            
                                var returnMedia: [[String: Any?]] = []
                                
                                for media in message.attachedMedia {
                                    returnMedia.append([
                                        "mediaSid": media.sid,
                                    ])
                                }
                                
                                var jsonData: Data? = nil
                                if (message.attributes()?.isDictionary ?? false) {
                                    do {
                                        jsonData = try JSONSerialization.data(withJSONObject: message.attributes()?.dictionary, options: .prettyPrinted)
                                    } catch let error as NSError {
                                        print(error)
                                    }
                                }
                                
                                returnMessages.append([
                                    "messageSid": message.sid,
                                    "messageBody": message.body,
                                    "messageIndex": message.index,
                                    "participantIdentity": message.participant?.identity,
                                    "date": message.dateCreated,
                                    "hasMedia": message.attachedMedia.count > 0,
                                    "attachedMedia": returnMedia,
                                    "attributes": jsonData != nil ? String(data: jsonData!,
                                                                           encoding: String.Encoding.ascii) : nil
                                ])
                            }
                            result(returnMessages)
                        } else {
                            result(nil)
                        }
                    }
                } else {
                    result(nil)
                }
            }
        case "sendMessage":
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["conversationSid"] as! String
            let text = arguments["text"] as? String
            let path = arguments["path"] as? String
            let mimeType = arguments["mimeType"] as? String ?? ""
            let fileName = arguments["fileName"] as? String ?? ""
            let attributes = arguments["attributes"] as? [String: Any]
            
            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    let messageBuilder = conversation?.prepareMessage()
                    if (text != nil) {
                        messageBuilder?.setBody(text!)
                    }
                    if (attributes != nil) {
                        messageBuilder?.setAttributes(TCHJsonAttributes(dictionary: attributes!), error: nil)
                    }
                    if (path != nil) {
                        if let inputStream = InputStream(fileAtPath: path!) {
                            messageBuilder?.addMedia(inputStream: inputStream, contentType: mimeType, filename: fileName)
                        }
                    }
                    messageBuilder?.buildAndSend() {(r, message) in
                        if(r.isSuccessful) {
                            result(true)
                        } else {
                            result(false)
                        }
                    }
                } else {
                    result(nil)
                }
            }
        case "typing":
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String

            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    conversation?.typing()
                    result(true)
                } else {
                    result(nil)
                }
            }
            
        case "getTemporaryContentUrlForMediaSid":
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String
            
            client?.getTemporaryContentUrlsFor(mediaSids: [sid], completion: { r, urls in
                if (r.isSuccessful) {
                    if (urls?.isEmpty ?? true) {
                        result(nil)
                    } else {
                        result(urls!.first!.value.absoluteString);
                    }
                } else {
                    result(nil);
                }
            })
            
        case "registerAPNToken":
            if (pushToken != nil) {
                client?.register(withNotificationToken: pushToken!) {r in
                    if (r.isSuccessful) {
                        result(true)
                    } else {
                        result(false);
                    }
                }
            } else {
                result(false);
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func conversationsClient(_ client: TwilioConversationsClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        SwiftTwilioConversationsPlugin.addToSink(data: [
            "event": "clientSynchronizationStatusUpdated",
            "status": status.rawValue,
        ])
    }
    
    public func conversationsClient(_ client: TwilioConversationsClient, conversationAdded conversation:TCHConversation) {
        SwiftTwilioConversationsPlugin.addToSink(data: [
            "event": "conversationAdded",
            "conversationSid": conversation.sid,
        ])
    }
    
    public func conversationsClient(_ client: TwilioConversationsClient, notificationAddedToConversationWithSid conversationSid:String) {
        SwiftTwilioConversationsPlugin.addToSink(data: [
            "event": "notificationAddedToConversation",
            "conversationSid": conversationSid,
        ])
    }
    
    public func conversationsClient(_ client: TwilioConversationsClient, user:TCHUser, updated:TCHUserUpdate) {
        SwiftTwilioConversationsPlugin.addToSink(data: [
            "event": "userUpdated",
            "identity": user.identity,
            "isOnline": user.isOnline(),
        ])
    }
    
    public func conversationsClient(_ client: TwilioConversationsClient, userSubscribed user:TCHUser) {
        SwiftTwilioConversationsPlugin.addToSink(data: [
            "event": "userSubscribed",
            "identity": user.identity,
            "isOnline": user.isOnline(),
        ])
    }
    
    public func conversationsClient(_ client: TwilioConversationsClient, userUnsubscribed user:TCHUser) {
        SwiftTwilioConversationsPlugin.addToSink(data: [
            "event": "userUnsubscribed",
            "identity": user.identity,
            "isOnline": user.isOnline(),
        ])
    }
}

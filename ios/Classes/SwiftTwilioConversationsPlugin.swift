import Flutter
import UIKit
import TwilioConversationsClient

public class SwiftTwilioConversationsPlugin: NSObject, FlutterPlugin, TwilioConversationsClientDelegate {
    private var client: TwilioConversationsClient?
    private static var conversationsStreamHandler: TwilioConversationsStreamHandler = TwilioConversationsStreamHandler()
    public static var conversationListeners: [String: ConversationListener] = [:]
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "twilio_conversations", binaryMessenger: registrar.messenger())
        let myEventChannel = FlutterEventChannel(name: "twilio_conversations_stream", binaryMessenger: registrar.messenger())
        myEventChannel.setStreamHandler(conversationsStreamHandler)
        
        let instance = SwiftTwilioConversationsPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    public static func addToSink(data: Any) {
        SwiftTwilioConversationsPlugin.conversationsStreamHandler.sink?(data)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "initClient":
            let arguments = call.arguments as! [String: Any]
            let token = arguments["token"] as! String
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
        case "getMessageByIndex":
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String
            let index = arguments["index"] as! Int
            
            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    conversation?.message(withIndex: NSNumber(value: index)) { (r, message) in
                        if(r.isSuccessful) {
                            result([
                                "messageSid": message?.sid,
                                "messageBody": message?.body,
                                "participantIdentity": message?.participant?.identity,
                            ])
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
            
        case "getMessages":
            let arguments = call.arguments as! [String: Any]
            let sid = arguments["sid"] as! String
            
            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    conversation?.getLastMessages(withCount: 100) { (r, messages) in
                        if(r.isSuccessful) {
                            var returnMessages: [[String: String?]] = []
                            
                            for message in messages ?? [] {
                                returnMessages.append([
                                    "messageSid": message.sid,
                                    "messageBody": message.body,
                                    "participantIdentity": message.participant?.identity,
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
            let sid = arguments["sid"] as! String
            let text = arguments["text"] as! String
            
            client?.conversation(withSidOrUniqueName: sid) {(r, conversation) in
                if (r.isSuccessful) {
                    conversation?.prepareMessage().setBody(text).buildAndSend() {(r, message) in
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
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func conversationsClient(_ client: TwilioConversationsClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        SwiftTwilioConversationsPlugin.conversationsStreamHandler.sink?(["synchronizationStatusUpdated": status.rawValue])
    }
    
    public func conversationsClient(_ client: TwilioConversationsClient, conversationAdded conversation:TCHConversation) {
        SwiftTwilioConversationsPlugin.conversationsStreamHandler.sink?(["conversationAdded": conversation.sid])
    }
    
    public func conversationsClient(_ client: TwilioConversationsClient, notificationAddedToConversationWithSid conversationSid:String) {
        SwiftTwilioConversationsPlugin.conversationsStreamHandler.sink?(["notificationAddedToConversationWithSid": conversationSid])
    }
}

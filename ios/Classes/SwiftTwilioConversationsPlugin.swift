import Flutter
import UIKit
import TwilioConversationsClient

public class SwiftTwilioConversationsPlugin: NSObject, FlutterPlugin, TwilioConversationsClientDelegate {
    private var client: TwilioConversationsClient?
    private static var conversationsStreamHandler: TwilioConversationsStreamHandler = TwilioConversationsStreamHandler()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "twilio_conversations", binaryMessenger: registrar.messenger())
        let myEventChannel = FlutterEventChannel(name: "twilio_conversations_stream", binaryMessenger: registrar.messenger())
        myEventChannel.setStreamHandler(conversationsStreamHandler)
        
        let instance = SwiftTwilioConversationsPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
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
                result(initResult.isSuccessful)
            }
        case "myConversations":
            var conversations: [String] = []
            
            for  conversation in client?.myConversations() ?? [] {
                conversations.append(conversation.friendlyName ?? "[unknown]")
            }
            
            result(conversations)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func conversationsClient(_ client: TwilioConversationsClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        SwiftTwilioConversationsPlugin.conversationsStreamHandler.sink?(status.rawValue)
        
        guard status == .completed else {
            return
        }
    }
}

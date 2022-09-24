import Flutter
import UIKit
import TwilioConversationsClient

public class SwiftTwilioConversationsPlugin: NSObject, FlutterPlugin, TwilioConversationsClientDelegate {
    private var client: TwilioConversationsClient?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "twilio_conversations", binaryMessenger: registrar.messenger())
        let instance = SwiftTwilioConversationsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
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
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

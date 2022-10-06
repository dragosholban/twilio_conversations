import Flutter
import TwilioConversationsClient

public class ConversationListener: NSObject, TCHConversationDelegate {
    let TAG = "ConversationListener"
    let conversationSid: String
    
    init(_ conversationSid: String) {
        self.conversationSid = conversationSid
    }
    
    // onMessageAdded
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        messageAdded message: TCHMessage) {
            debug("onMessageAdded => messageSid = \(String(describing: message.sid))")
            var returnMedia: [[String: Any?]] = []
            
            for media in message.attachedMedia {
                returnMedia.append([
                    "mediaSid": media.sid,
                ])
            }
            
            SwiftTwilioConversationsPlugin.addToSink(data: [
                "event": "messageAdded",
                "conversationSid": conversation.sid,
                "messageSid": message.sid,
                "messageBody": message.body,
                "messageIndex": message.index,
                "date": message.dateCreated,
                "participantIdentity": message.participant?.identity,
                "hasMedia": message.attachedMedia.count > 0,
                "attachedMedia": returnMedia,
            ])
        }
    
    // onMessageUpdated
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        message: TCHMessage,
        updated: TCHMessageUpdate) {
            debug("onMessageUpdated => messageSid = \(String(describing: message.sid)), " +
                  "updated = \(String(describing: updated))")
            SwiftTwilioConversationsPlugin.addToSink(data: [
                "event": "messageUpdated",
                "conversationSid": conversation.sid,
                "messageSid": message.sid,
                "messageBody": message.body,
                "messageIndex": message.index,
                "date": message.dateCreated,
                "participantIdentity": message.participant?.identity,
            ])
        }
    
    // onMessageDeleted
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        messageDeleted message: TCHMessage) {
            debug("onMessageDeleted => messageSid = \(String(describing: message.sid))")
            SwiftTwilioConversationsPlugin.addToSink(data: [
                "event": "messageDeleted",
                "conversationSid": conversation.sid,
                "messageSid": message.sid,
                "messageBody": message.body,
                "messageIndex": message.index,
                "date": message.dateCreated,
                "participantIdentity": message.participant?.identity,
            ])
        }
    
    // onParticipantAdded
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        participantJoined participant: TCHParticipant) {
            debug("onParticipantAdded => participantSid = \(String(describing: participant.sid))")
            SwiftTwilioConversationsPlugin.addToSink(data: [
                "event": "participantAdded",
                "conversationSid": conversation.sid,
                "participantSid": participant.sid,
                "lastReadMessageIndex": participant.lastReadMessageIndex,
            ])
        }
    
    // onParticipantUpdated
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        participant: TCHParticipant,
        updated: TCHParticipantUpdate) {
            debug("onParticipantUpdated => participantSid = \(String(describing: participant.sid)), " +
                  "updated = \(String(describing: updated))")
            SwiftTwilioConversationsPlugin.addToSink(data: [
                "event": "participantUpdated",
                "conversationSid": conversation.sid,
                "participantSid": participant.sid,
                "participantIdentity": participant.identity,
                "lastReadMessageIndex": participant.lastReadMessageIndex,
                "reason": updated.rawValue,
            ])
        }
    
    // onParticipantDeleted
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        participantLeft participant: TCHParticipant) {
            debug("onParticipantDeleted => participantSid = \(String(describing: participant.sid))")
            SwiftTwilioConversationsPlugin.addToSink(data: [
                "event": "participantDeleted",
                "conversationSid": conversation.sid,
                "participantSid": participant.sid,
            ])
        }
    
    // onTypingStarted
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        typingStartedOn conversation: TCHConversation,
        participant: TCHParticipant) {
            debug("onTypingStarted => conversationSid = \(String(describing: conversation.sid)), " +
                  "participantSid = \(String(describing: participant.sid))")
            SwiftTwilioConversationsPlugin.addToSink(data: [
                "event": "typingStarted",
                "conversationSid": conversation.sid,
            ])
        }
    
    // onTypingEnded
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        typingEndedOn conversation: TCHConversation,
        participant: TCHParticipant) {
            debug("onTypingEnded => conversationSid = \(String(describing: conversation.sid)), " +
                  "participantSid = \(String(describing: participant.sid))")
            SwiftTwilioConversationsPlugin.addToSink(data: [
                "event": "typingEnded",
                "conversationSid": conversation.sid,
            ])
            
        }
    
    // onSynchronizationChanged
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        synchronizationStatusUpdated status: TCHConversationSynchronizationStatus) {
            let syncStatus = conversationSynchronizationStatusToString(conversation.synchronizationStatus)
            debug("onSynchronizationChanged => sid: \(String(describing: conversation.sid)), status: \(syncStatus)")
            SwiftTwilioConversationsPlugin.addToSink(data: [
                "event": "synchronizationChanged",
                "conversationSid": conversation.sid,
                "status": syncStatus,
            ])
        }
    
    // The ConversationListener Protocol for iOS duplicates some of the events
    // that are provided via the ClientListener protocol on both Android and iOS.
    // In the interest of functional parity and avoid duplicate notifications,
    // we will not notify the dart layer of such event from the ConversationListener.
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        participant: TCHParticipant,
        userSubscribed user: TCHUser) {
            // userSubscribed
        }
    
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        participant: TCHParticipant,
        userUnsubscribed user: TCHUser) {
            // userUnsubscribed
        }
    
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        participant: TCHParticipant,
        user: TCHUser,
        updated: TCHUserUpdate) {
            // userUpdated
        }
    
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversationDeleted conversation: TCHConversation) {
            // onConversationDeleted
        }
    
    public func conversationsClient(
        _ client: TwilioConversationsClient,
        conversation: TCHConversation,
        updated: TCHConversationUpdate) {
            // onConversationUpdated
        }
    
    private func debug(_ msg: String) {
        NSLog("\(TAG)::\(msg)")
    }
    
    public func conversationSynchronizationStatusToString(
        _ syncStatus: TCHConversationSynchronizationStatus) -> String {
            let syncStatusString: String
            
            switch syncStatus {
            case .none:
                syncStatusString = "NONE"
            case .identifier:
                syncStatusString = "IDENTIFIER"
            case .metadata:
                syncStatusString = "METADATA"
            case .all:
                syncStatusString = "ALL"
            case .failed:
                syncStatusString = "FAILED"
            @unknown default:
                syncStatusString = "UNKNOWN"
            }
            
            return syncStatusString
        }
    
    private func conversationStatusToString(_ conversationStatus: TCHConversationStatus) -> String {
        let conversationStatusString: String
        
        switch conversationStatus {
        case .joined:
            conversationStatusString = "JOINED"
        case .notParticipating:
            conversationStatusString = "NOT_PARTICIPATING"
        @unknown default:
            conversationStatusString = "UNKNOWN"
        }
        
        return conversationStatusString
    }
}

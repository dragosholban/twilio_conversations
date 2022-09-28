package com.example.twilio_conversations.listeners

import android.util.Log
import com.example.twilio_conversations.TwilioConversationsPlugin
import com.twilio.conversations.Conversation
import com.twilio.conversations.ConversationListener
import com.twilio.conversations.Message
import com.twilio.conversations.Participant

class ConversationListenerImpl(private val conversationSid: String) : ConversationListener {
    private val TAG = "ConversationListener"

    override fun onMessageAdded(message: Message) {
        Log.d(TAG, "onMessageAdded => messageSid = ${message.sid}")
        TwilioConversationsPlugin.conversationsStreamHandler.sink?.success(
            hashMapOf<String, String?>(
                "event" to "messageAdded",
                "conversationSid" to conversationSid,
                "messageSid" to message?.sid,
                "messageBody" to message?.body,
                "participantIdentity" to message?.participant.identity,
            )
        )
//        TwilioConversationsPlugin.flutterClientApi.messageAdded(
//            conversationSid,
//            Mapper.messageToPigeon(message)) {}
    }

    override fun onMessageUpdated(message: Message, reason: Message.UpdateReason) {
        Log.d(TAG, "onMessageUpdated => messageSid = ${message.sid}, reason = $reason")
//        TwilioConversationsPlugin.flutterClientApi.messageUpdated(
//            conversationSid,
//            Mapper.messageToPigeon(message),
//            reason.toString()) {}
    }

    override fun onMessageDeleted(message: Message) {
        Log.d(TAG, "onMessageDeleted => messageSid = ${message.sid}")
//        TwilioConversationsPlugin.flutterClientApi.messageDeleted(
//            conversationSid,
//            Mapper.messageToPigeon(message)) {}
    }

    override fun onParticipantAdded(participant: Participant) {
        Log.d(TAG, "onParticipantAdded => participantSid = ${participant.sid}")
//        TwilioConversationsPlugin.flutterClientApi.participantAdded(
//            conversationSid,
//            Mapper.participantToPigeon(participant)) {}
    }

    override fun onParticipantUpdated(participant: Participant, reason: Participant.UpdateReason) {
        Log.d(TAG, "onParticipantUpdated => participantSid = ${participant.sid}, reason = $reason")
//        TwilioConversationsPlugin.flutterClientApi.participantUpdated(
//            conversationSid,
//            Mapper.participantToPigeon(participant),
//            reason.toString()) {}
    }

    override fun onParticipantDeleted(participant: Participant) {
        Log.d(TAG, ".onParticipantDeleted => participantSid = ${participant.sid}")
//        TwilioConversationsPlugin.flutterClientApi.participantDeleted(
//            conversationSid,
//            Mapper.participantToPigeon(participant)) {}
    }

    override fun onTypingStarted(conversation: Conversation, participant: Participant) {
        Log.d(
            TAG,
            "onTypingStarted => conversationSid = ${conversation.sid}, participantSid = ${conversation.sid}"
        )
//        TwilioConversationsPlugin.flutterClientApi.typingStarted(
//            conversationSid,
//            Mapper.conversationToPigeon(conversation),
//            Mapper.participantToPigeon(participant)) {}
    }

    override fun onTypingEnded(conversation: Conversation, participant: Participant) {
        Log.d(
            TAG,
            "onTypingEnded => conversationSid = ${conversation.sid}, participantSid = ${participant.sid}"
        )
//        TwilioConversationsPlugin.flutterClientApi.typingEnded(
//            conversationSid,
//            Mapper.conversationToPigeon(conversation),
//            Mapper.participantToPigeon(participant)) {}
    }

    override fun onSynchronizationChanged(conversation: Conversation) {
        Log.d(
            TAG,
            "onSynchronizationChanged => sid: ${conversation.sid}, status: ${conversation.synchronizationStatus}"
        )
//        TwilioConversationsPlugin.flutterClientApi.synchronizationChanged(
//            conversationSid,
//            Mapper.conversationToPigeon(conversation)) {}
    }
}

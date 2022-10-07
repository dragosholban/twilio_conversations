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
        val returnMedia = emptyList<HashMap<String, Any?>>().toMutableList()

        message.attachedMedia.forEach { media ->
            returnMedia.add(
                hashMapOf<String, Any?>(
                    "mediaSid" to media.sid,
                )
            )
        }

        TwilioConversationsPlugin.conversationsStreamHandler.sink?.success(
            hashMapOf<String, Any?>(
                "event" to "messageAdded",
                "conversationSid" to conversationSid,
                "messageSid" to message.sid,
                "messageBody" to message.body,
                "messageIndex" to message.messageIndex,
                "date" to message.dateCreated,
                "participantIdentity" to message.participant.identity,
                "hasMedia" to message.attachedMedia.isNotEmpty(),
                "attachedMedia" to returnMedia,
            )
        )
    }

    override fun onMessageUpdated(message: Message, reason: Message.UpdateReason) {
        Log.d(TAG, "onMessageUpdated => messageSid = ${message.sid}, reason = $reason")
        TwilioConversationsPlugin.conversationsStreamHandler.sink?.success(
            hashMapOf<String, Any?>(
                "event" to "messageUpdated",
                "conversationSid" to conversationSid,
                "messageSid" to message.sid,
                "messageBody" to message.body,
                "messageIndex" to message.messageIndex,
                "date" to message.dateCreated,
                "participantIdentity" to message.participant.identity,
            )
        )
    }

    override fun onMessageDeleted(message: Message) {
        Log.d(TAG, "onMessageDeleted => messageSid = ${message.sid}")
        TwilioConversationsPlugin.conversationsStreamHandler.sink?.success(
            hashMapOf<String, Any?>(
                "event" to "messageDeleted",
                "conversationSid" to conversationSid,
                "messageSid" to message.sid,
                "messageBody" to message.body,
                "messageIndex" to message.messageIndex,
                "date" to message.dateCreated,
                "participantIdentity" to message.participant.identity,
            )
        )
    }

    override fun onParticipantAdded(participant: Participant) {
        Log.d(TAG, "onParticipantAdded => participantSid = ${participant.sid}")
        TwilioConversationsPlugin.conversationsStreamHandler.sink?.success(
            hashMapOf<String, Any?>(
                "event" to "participantAdded",
                "conversationSid" to conversationSid,
                "participantSid" to participant.sid,
                "participantIdentity" to participant.identity,
                "lastReadMessageIndex" to participant.lastReadMessageIndex,
            )
        )
    }

    override fun onParticipantUpdated(participant: Participant, reason: Participant.UpdateReason) {
        Log.d(TAG, "onParticipantUpdated => participantSid = ${participant.sid}, reason = $reason")
        TwilioConversationsPlugin.conversationsStreamHandler.sink?.success(
            hashMapOf<String, Any?>(
                "event" to "participantUpdated",
                "conversationSid" to conversationSid,
                "participantSid" to participant.sid,
                "participantIdentity" to participant.identity,
                "lastReadMessageIndex" to participant.lastReadMessageIndex,
                "reason" to reason.value,
            )
        )
    }

    override fun onParticipantDeleted(participant: Participant) {
        Log.d(TAG, ".onParticipantDeleted => participantSid = ${participant.sid}")
        TwilioConversationsPlugin.conversationsStreamHandler.sink?.success(
            hashMapOf<String, String?>(
                "event" to "participantDeleted",
                "conversationSid" to conversationSid,
                "participantSid" to participant.sid,
                "participantIdentity" to participant.identity,
            )
        )
    }

    override fun onTypingStarted(conversation: Conversation, participant: Participant) {
        Log.d(
            TAG,
            "onTypingStarted => conversationSid = ${conversation.sid}, participantSid = ${participant.sid}"
        )
        TwilioConversationsPlugin.conversationsStreamHandler.sink?.success(
            hashMapOf<String, String?>(
                "event" to "typingStarted",
                "conversationSid" to conversationSid,
                "participantSid" to participant.sid,
                "participantIdentity" to participant.identity,
            )
        )
    }

    override fun onTypingEnded(conversation: Conversation, participant: Participant) {
        Log.d(
            TAG,
            "onTypingEnded => conversationSid = ${conversation.sid}, participantSid = ${participant.sid}"
        )
        TwilioConversationsPlugin.conversationsStreamHandler.sink?.success(
            hashMapOf<String, String?>(
                "event" to "typingEnded",
                "conversationSid" to conversationSid,
                "participantSid" to participant.sid,
                "participantIdentity" to participant.identity,
            )
        )
    }

    override fun onSynchronizationChanged(conversation: Conversation) {
        Log.d(
            TAG,
            "onSynchronizationChanged => sid: ${conversation.sid}, status: ${conversation.synchronizationStatus}"
        )
        TwilioConversationsPlugin.conversationsStreamHandler.sink?.success(
            hashMapOf<String, String?>(
                "event" to "synchronizationChanged",
                "conversationSid" to conversationSid,
                "status" to conversation.synchronizationStatus.name,
            )
        )
    }
}

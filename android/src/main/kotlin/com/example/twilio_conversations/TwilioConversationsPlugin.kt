package com.example.twilio_conversations

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.example.twilio_conversations.listeners.ConversationListenerImpl
import com.twilio.conversations.*
import com.twilio.conversations.extensions.getConversation
import com.twilio.conversations.extensions.getTemporaryContentUrlsForMediaSids
import com.twilio.util.ErrorInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.io.FileInputStream
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.HashMap


/** TwilioConversationsPlugin */
class TwilioConversationsPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private val TAG = TwilioConversationsPlugin::class.qualifiedName
    var conversationListeners: HashMap<String, ConversationListener> = hashMapOf()

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var context: Context
    private lateinit var activity: Activity
    private var result: Result? = null

    private var conversationsClient: ConversationsClient? = null

    companion object {
        var conversationsStreamHandler: TwilioConversationsStreamHandler =
            TwilioConversationsStreamHandler()
    }

    // The scope for the UI thread
    private val mainScope = CoroutineScope(Dispatchers.IO)

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "twilio_conversations")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext

        val myEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "twilio_conversations_stream")
        myEventChannel.setStreamHandler(conversationsStreamHandler)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        this.result = result

        when (call.method) {
            "initClient" -> {
                val token = call.argument<String>("token") ?: ""
                val props = ConversationsClient.Properties.newBuilder().createProperties()
                try {
                    conversationsClient?.removeAllListeners()
                    conversationsClient?.shutdown()
                } catch (e: Exception) {
                    Log.d(TAG, "initClient shutdown: ${e.message}")
                }
                conversationListeners.clear()
                ConversationsClient.create(context, token, props, mConversationsClientCallback)
            }
            "shutdown" -> {
                try {
                    conversationsClient?.removeAllListeners()
                    conversationsClient?.shutdown()
                } catch (e: Exception) {
                    Log.d(TAG, "shutdown: ${e.message}")
                }
                conversationListeners.clear()
                result.success(true)
            }
            "myConversations" -> {
                val conversations = emptyList<HashMap<String, Any?>>().toMutableList()
                try {
                    conversationsClient?.myConversations?.forEach { conversation ->
                        conversations += hashMapOf(
                            Pair("sid", conversation.sid),
                            Pair("friendlyName", conversation.friendlyName),
                            Pair("lastMessageDate", dateToString(conversation.lastMessageDate)),
                            Pair("lastMessageIndex", conversation.lastMessageIndex),
                        )

                        // Setting flutter event listener for the given channel if one does not yet exist.
                        if (conversation.sid != null && !conversationListeners.containsKey(
                                conversation.sid
                            )
                        ) {
                            Log.d(
                                TAG,
                                "setupConversationListener => conversation: ${conversation.sid}"
                            )
                            conversationListeners[conversation.sid] =
                                ConversationListenerImpl(conversation.sid)
                            conversation.addListener(conversationListeners[conversation.sid])
                        }
                    }
                } catch (e: Exception) {
                    Log.d(TAG, "myConversations: ${e.message}")
                }

                result.success(conversations)
            }
            "getConversation" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(sid)
                            if (conversation != null) {
                                var lastReadMessageIndex: Long? = null
                                if (conversation.synchronizationStatus == Conversation.SynchronizationStatus.ALL) {
                                    conversation.participantsList?.forEach { participant ->
                                        if (participant.identity != conversationsClient?.myIdentity) {
                                            lastReadMessageIndex = participant.lastReadMessageIndex
                                        }
                                    }
                                }
                                result.success(
                                    hashMapOf(
                                        Pair("sid", conversation.sid),
                                        Pair("friendlyName", conversation.friendlyName),
                                        Pair(
                                            "lastMessageDate",
                                            dateToString(conversation.lastMessageDate),
                                        ),
                                        Pair("lastMessageIndex", conversation.lastMessageIndex),
                                        Pair("attributes", conversation.attributes.toString()),
                                        Pair("lastReadMessageIndex", lastReadMessageIndex),
                                    )
                                )
                            } else {
                                result.success(hashMapOf<String, String?>())
                            }
                        } catch (e: Exception) {
                            Log.d(TAG, "getConversation: ${e.message}")
                            result.error("getConversation", e.message, "")
                        }
                    }
                }
            }
            "getMessageByIndex" -> {
                val sid = call.argument<String>("sid") ?: ""
                val index = call.argument<Int>("index")

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(sid)
                            index?.let { index ->
                                if (conversation?.synchronizationStatus == Conversation.SynchronizationStatus.ALL) {
                                    conversation.getMessageByIndex(
                                        index.toLong(),
                                        CallbackListener<Message>() {

                                            val returnMedia =
                                                emptyList<HashMap<String, Any?>>().toMutableList()

                                            it.attachedMedia.forEach { media ->
                                                returnMedia.add(
                                                    hashMapOf<String, Any?>(
                                                        "mediaSid" to media.sid,
                                                        "mediaContentType" to media.contentType,
                                                    )
                                                )
                                            }

                                            result.success(
                                                hashMapOf<String, Any?>(
                                                    "sid" to it.sid,
                                                    "body" to it.body,
                                                    "messageIndex" to it.messageIndex,
                                                    "dateCreated" to it.dateCreated,
                                                    "participant.sid" to it.participant?.sid,
                                                    "participant.conversationSid" to it.participant?.conversation?.sid,
                                                    "participant.identity" to it.participant?.identity,
                                                    "participant.attributes" to it.participant?.attributes.toString(),
                                                    "hasMedia" to it.attachedMedia.isNotEmpty(),
                                                    "attachedMedia" to returnMedia,
                                                    "attributes" to it.attributes.toString(),
                                                )
                                            )
                                        })
                                } else {
                                    result.success(null)
                                }
                            }
                        } catch (e: Exception) {
                            Log.d(TAG, "getMessageByIndex: ${e.message}")
                            result.error("getMessageByIndex", e.message, "");
                        }
                    }
                }
            }
            "getMessagesCount" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(sid)

                            conversation?.getMessagesCount() {
                                result.success(it)
                            }
                        } catch (e: Exception) {
                            Log.d(TAG, "getUnreadMessagesCount: ${e.message}")
                            result.error("getUnreadMessagesCount", e.message, "");
                        }
                    }
                }
            }
            "getUnreadMessagesCount" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(sid)

                            conversation?.getUnreadMessagesCount() {
                                result.success(it)
                            }
                        } catch (e: Exception) {
                            result.error("getUnreadMessagesCount", e.message, "");
                        }
                    }
                }
            }
            "getConversationUserIsOnline" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(sid)

                            if (conversation?.synchronizationStatus == Conversation.SynchronizationStatus.ALL) {
                                conversation.participantsList?.forEach { participant ->
                                    if (participant.identity != conversationsClient?.myIdentity) {
                                        participant.getAndSubscribeUser { user ->
                                            result.success(user?.isOnline);
                                        }
                                    }
                                }
                            }
                        } catch (e: Exception) {
                            Log.d(TAG, "getConversationUserIsOnline: ${e.message}")
                            result.error("getConversationUserIsOnline", e.message, "");
                        }
                    }
                }
            }
            "setAllMessagesRead" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(sid)

                            conversation?.setAllMessagesRead() {
                                result.success(it)
                            }
                        } catch (e: Exception) {
                            Log.d(TAG, "setAllMessagesRead: ${e.message}")
                            result.error("setAllMessagesRead", e.message, "");
                        }
                    }
                }
            }
            "getMessages" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(sid)
                            conversation?.getLastMessages(
                                100
                            ) { messages ->
                                val returnMessages =
                                    emptyList<HashMap<String, Any?>>().toMutableList()
                                messages?.forEach {

                                    val returnMedia =
                                        emptyList<HashMap<String, Any?>>().toMutableList()

                                    it.attachedMedia.forEach { media ->
                                        returnMedia.add(
                                            hashMapOf<String, Any?>(
                                                "mediaSid" to media.sid,
                                                "mediaContentType" to media.contentType,
                                            )
                                        )
                                    }

                                    returnMessages.add(
                                        hashMapOf<String, Any?>(
                                            "sid" to it.sid,
                                            "body" to it.body,
                                            "messageIndex" to it.messageIndex,
                                            "dateCreated" to it.dateCreated,
                                            "participant.sid" to it.participant?.sid,
                                            "participant.conversationSid" to it.participant?.conversation?.sid,
                                            "participant.identity" to it.participant?.identity,
                                            "participant.attributes" to it.participant?.attributes.toString(),
                                            "hasMedia" to it.attachedMedia.isNotEmpty(),
                                            "attachedMedia" to returnMedia,
                                            "attributes" to it.attributes.toString(),
                                        )
                                    )
                                }
                                result.success(returnMessages)
                            }
                        } catch (e: Exception) {
                            Log.d(TAG, "getMessages: ${e.message}")
                            result.error("getMessages", e.message, "");
                        }
                    }
                }
            }
            "getTemporaryContentUrlForMediaSid" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val urls: Map<String, String>? =
                                conversationsClient?.getTemporaryContentUrlsForMediaSids(listOf(sid))
                            if (urls?.isEmpty() != false) {
                                result.success(null)
                            } else {
                                result.success(urls.entries.first().value)
                            }
                        } catch (e: Exception) {
                            Log.d(TAG, "getTemporaryContentUrlForMediaSid: ${e.message}")
                            result.error("getTemporaryContentUrlForMediaSid", e.message, "");
                        }
                    }
                }
            }
            "sendMessage" -> {
                val sid = call.argument<String>("conversationSid") ?: ""
                val text = call.argument<String?>("text")
                val path = call.argument<String?>("path")
                val mimeType = call.argument<String>("mimeType") ?: ""
                val fileName = call.argument<String>("fileName") ?: ""
                val attributes = call.argument<Map<String, Any>>("attributes")

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(sid)
                            val messageBuilder = conversation?.prepareMessage()
                            if (text != null) {
                                messageBuilder?.setBody(text)
                            }
                            if (attributes != null) {
                                messageBuilder?.setAttributes(Attributes(JSONObject(attributes)))
                            }
                            if (path != null) {
                                val inputStream = FileInputStream(path)
                                val uploadLister = MediaUploadListener()
                                messageBuilder?.addMedia(
                                    inputStream,
                                    mimeType,
                                    fileName,
                                    uploadLister
                                )
                            }
                            messageBuilder?.buildAndSend() {
                                result.success(true)
                            }
                        } catch (e: Exception) {
                            Log.d(TAG, "sendMessage: ${e.message}")
                            result.error("sendMessage", e.message, "");
                        }
                    }
                }
            }
            "typing" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(sid)
                            conversation?.typing()
                            result.success(true)
                        } catch (e: Exception) {
                            Log.d(TAG, "typing: ${e.message}")
                            result.error("typing", e.message, "");
                        }
                    }
                }
            }
            "registerFCMToken" -> {
                val token = call.argument<String>("token") ?: ""

                try {
                    conversationsClient?.registerFCMToken(ConversationsClient.FCMToken(token)) {}
                } catch (e: Exception) {
                    Log.d(TAG, "registerFCMToken: ${e.message}")
                    result.error("registerFCMToken", e.message, "");
                }
            }
            "conversation.getParticipantsList" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(sid)
                            val participants =
                                emptyList<HashMap<String, Any?>>().toMutableList()
                            conversation?.participantsList?.forEach {
                                participants.add(
                                    hashMapOf<String, Any?>(
                                        "sid" to it.sid,
                                        "conversationSid" to it.conversation.sid,
                                        "identity" to it.identity,
                                        "attributes" to it.attributes.toString(),
                                    )
                                )
                            }
                            result.success(participants)
                        } catch (e: Exception) {
                            Log.d(TAG, "conversation.getParticipantsList: ${e.message}")
                            result.error("conversation.getParticipantsList", e.message, "");
                        }
                    }
                }
            }
            "participant.getUser" -> {
                val conversationSid = call.argument<String>("conversationSid") ?: ""
                val participantSid = call.argument<String>("participantSid")

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        try {
                            val conversation = conversationsClient?.getConversation(conversationSid)
                            participantSid?.let { participantSid ->
                                if (conversation?.synchronizationStatus == Conversation.SynchronizationStatus.ALL) {
                                    val participant =
                                        conversation.getParticipantBySid(participantSid)

                                    participant.getAndSubscribeUser {
                                        result.success(
                                            hashMapOf<String, Any?>(
                                                "identity" to it.identity,
                                                "friendlyName" to it.friendlyName,
                                                "attributes" to it.attributes.toString(),
                                                "isOnline" to it.isOnline,
                                            )
                                        )
                                    }
                                } else {
                                    result.success(null)
                                }
                            }
                        } catch (e: Exception) {
                            Log.d(TAG, "participant.getUser: ${e.message}")
                            result.error("participant.getUser", e.message, "");
                        }
                    }
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private val mConversationsClientCallback: CallbackListener<ConversationsClient> =
        object : CallbackListener<ConversationsClient> {
            override fun onSuccess(conversationsClient: ConversationsClient) {
                this@TwilioConversationsPlugin.conversationsClient = conversationsClient
                conversationsStreamHandler.sink?.success(
                    hashMapOf<String, Any?>(
                        "event" to "clientCreated",
                        "identity" to conversationsClient.myIdentity,
                        "reachabilityEnabled" to conversationsClient.isReachabilityEnabled,
                    )
                )
                conversationsClient.addListener(this@TwilioConversationsPlugin.mConversationsClientListener)
                Log.d(TAG, "Success creating Twilio Conversations Client")
                try {
                    this@TwilioConversationsPlugin.result?.success(true)
                } catch (e: Exception) {
                    Log.e(TAG, e.message ?: "")
                }
            }

            override fun onError(errorInfo: ErrorInfo) {
                Log.e(
                    TAG,
                    "Error creating Twilio Conversations Client: " + errorInfo.message
                )
                this@TwilioConversationsPlugin.result?.success(false)
            }
        }

    private val mConversationsClientListener: ConversationsClientListener =
        object : ConversationsClientListener {
            override fun onConversationAdded(conversation: Conversation?) {
                conversationsStreamHandler.sink?.success(
                    hashMapOf<String, String?>(
                        "event" to "conversationAdded",
                        "conversationSid" to conversation?.sid,
                    )
                )
            }

            override fun onConversationUpdated(
                conversation: Conversation?,
                reason: Conversation.UpdateReason?
            ) {

            }

            override fun onConversationDeleted(conversation: Conversation?) {

            }

            override fun onConversationSynchronizationChange(conversation: Conversation?) {

            }

            override fun onError(errorInfo: ErrorInfo?) {

            }

            override fun onUserUpdated(user: User?, reason: User.UpdateReason?) {
                conversationsStreamHandler.sink?.success(
                    hashMapOf<String, Any?>(
                        "event" to "userUpdated",
                        "identity" to user?.identity,
                        "isOnline" to user?.isOnline,
                    )
                )
            }

            override fun onUserSubscribed(user: User?) {
                conversationsStreamHandler.sink?.success(
                    hashMapOf<String, Any?>(
                        "event" to "userSubscribed",
                        "identity" to user?.identity,
                        "isOnline" to user?.isOnline,
                    )
                )
            }

            override fun onUserUnsubscribed(user: User?) {
                conversationsStreamHandler.sink?.success(
                    hashMapOf<String, Any?>(
                        "event" to "userUnsubscribed",
                        "identity" to user?.identity,
                        "isOnline" to user?.isOnline,
                    )
                )
            }

            override fun onClientSynchronization(synchronizationStatus: ConversationsClient.SynchronizationStatus) {
                conversationsStreamHandler.sink?.success(
                    hashMapOf<String, Any>(
                        "event" to "clientSynchronizationStatusUpdated",
                        "status" to synchronizationStatus.value,
                    )
                )
            }

            override fun onNewMessageNotification(
                conversationSid: String?,
                messageSid: String?,
                messageIndex: Long
            ) {

            }

            override fun onAddedToConversationNotification(conversationSid: String?) {
                conversationsStreamHandler.sink?.success(
                    hashMapOf<String, String?>(
                        "event" to "notificationAddedToConversation",
                        "conversationSid" to conversationSid,
                    )
                )
            }

            override fun onRemovedFromConversationNotification(conversationSid: String?) {

            }

            override fun onNotificationSubscribed() {

            }

            override fun onNotificationFailed(errorInfo: ErrorInfo?) {

            }

            override fun onConnectionStateChange(state: ConversationsClient.ConnectionState?) {

            }

            override fun onTokenExpired() {

            }

            override fun onTokenAboutToExpire() {

            }
        }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    private fun dateToString(date: Date?): String? {
        if (date == null) return null
        val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
        return dateFormat.format(date)
    }
}

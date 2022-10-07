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
        lateinit var conversationsStreamHandler: TwilioConversationsStreamHandler
    }

    // The scope for the UI thread
    private val mainScope = CoroutineScope(Dispatchers.IO)

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "twilio_conversations")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        conversationsStreamHandler = TwilioConversationsStreamHandler()

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
                conversationsClient?.shutdown()
                conversationListeners.clear()
                ConversationsClient.create(context, token, props, mConversationsClientCallback)
            }
            "myConversations" -> {
                val conversations = emptyList<HashMap<String, Any?>>().toMutableList()
                conversationsClient?.myConversations?.forEach { conversation ->
                    conversations += hashMapOf(
                        Pair("sid", conversation.sid),
                        Pair("friendlyName", conversation.friendlyName),
                        Pair("lastMessageDate", dateToString(conversation.lastMessageDate)),
                        Pair("lastMessageIndex", conversation.lastMessageIndex),
                    )

                    // Setting flutter event listener for the given channel if one does not yet exist.
                    if (conversation.sid != null && !conversationListeners.containsKey(conversation.sid)) {
                        Log.d(TAG, "setupConversationListener => conversation: ${conversation.sid}")
                        conversationListeners[conversation.sid] =
                            ConversationListenerImpl(conversation.sid)
                        conversation.addListener(conversationListeners[conversation.sid])
                    }
                }

                result.success(conversations)
            }
            "getConversation" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        val conversation = conversationsClient?.getConversation(sid)
                        if (conversation != null) {
                            result.success(
                                hashMapOf(
                                    Pair("sid", conversation.sid),
                                    Pair("friendlyName", conversation.friendlyName),
                                    Pair(
                                        "lastMessageDate",
                                        dateToString(conversation.lastMessageDate),
                                    ),
                                    Pair("lastMessageIndex", conversation.lastMessageIndex)
                                )
                            )
                        } else {
                            result.success(hashMapOf<String, String?>());
                        }
                    }
                }
            }
            "getMessageByIndex" -> {
                val sid = call.argument<String>("sid") ?: ""
                val index = call.argument<Int>("index")

                mainScope.launch {
                    withContext(Dispatchers.IO) {
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
                                                )
                                            )
                                        }

                                        result.success(
                                            hashMapOf<String, Any?>(
                                                "messageSid" to it.sid,
                                                "messageBody" to it.body,
                                                "messageIndex" to it.messageIndex,
                                                "date" to it.dateCreated,
                                                "participantIdentity" to it.participant.identity,
                                                "hasMedia" to it.attachedMedia.isNotEmpty(),
                                                "attachedMedia" to returnMedia,
                                            )
                                        )
                                    })
                            } else {
                                result.success(null)
                            }
                        }
                    }
                }
            }
            "getMessagesCount" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        val conversation = conversationsClient?.getConversation(sid)

                        conversation?.getMessagesCount() {
                            result.success(it)
                        }
                    }
                }
            }
            "getUnreadMessagesCount" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        val conversation = conversationsClient?.getConversation(sid)

                        conversation?.getUnreadMessagesCount() {
                            result.success(it)
                        }
                    }
                }
            }
            "getConversationUserIsOnline" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
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
                    }
                }
            }
            "setAllMessagesRead" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        val conversation = conversationsClient?.getConversation(sid)

                        conversation?.setAllMessagesRead() {
                            result.success(it)
                        }
                    }
                }
            }
            "getMessages" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        val conversation = conversationsClient?.getConversation(sid)
                        conversation?.getLastMessages(
                            100
                        ) { messages ->
                            val returnMessages =
                                emptyList<HashMap<String, Any?>>().toMutableList()
                            messages?.forEach {

                                val returnMedia = emptyList<HashMap<String, Any?>>().toMutableList()

                                it.attachedMedia.forEach { media ->
                                    returnMedia.add(
                                        hashMapOf<String, Any?>(
                                            "mediaSid" to media.sid,
                                        )
                                    )
                                }

                                returnMessages.add(
                                    hashMapOf<String, Any?>(
                                        "messageSid" to it.sid,
                                        "messageBody" to it.body,
                                        "messageIndex" to it.messageIndex,
                                        "date" to it.dateCreated,
                                        "participantIdentity" to it.participant.identity,
                                        "hasMedia" to it.attachedMedia.isNotEmpty(),
                                        "attachedMedia" to returnMedia,
                                    )
                                )
                            }
                            result.success(returnMessages)
                        }
                    }
                }
            }
            "getTemporaryContentUrlForMediaSid" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        val urls: Map<String, String>? =
                            conversationsClient?.getTemporaryContentUrlsForMediaSids(listOf(sid))
                        if (urls?.isEmpty() != false) {
                            result.success(null)
                        } else {
                            result.success(urls.entries.first().value)
                        }
                    }
                }
            }
            "sendMessage" -> {
                val sid = call.argument<String>("sid") ?: ""
                val text = call.argument<String?>("text")
                val path = call.argument<String?>("path")
                val mimeType = call.argument<String>("mimeType") ?: ""
                val fileName = call.argument<String>("fileName") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        val conversation = conversationsClient?.getConversation(sid)
                        val messageBuilder = conversation?.prepareMessage()
                        if (text != null) {
                            messageBuilder?.setBody(text)
                        }
                        if (path != null) {
                            val inputStream = FileInputStream(path)
                            val uploadLister = MediaUploadListener()
                            messageBuilder?.addMedia(inputStream, mimeType, fileName, uploadLister)
                        }
                        messageBuilder?.buildAndSend() {
                            result.success(true)
                        }
                    }
                }
            }
            "typing" -> {
                val sid = call.argument<String>("sid") ?: ""

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        val conversation = conversationsClient?.getConversation(sid)
                        conversation?.typing()
                        result.success(true)
                    }
                }
            }
            "registerFCMToken" -> {
                val token = call.argument<String>("token") ?: ""

                conversationsClient?.registerFCMToken(ConversationsClient.FCMToken(token)) {}
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
                this@TwilioConversationsPlugin.result?.success(true)
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

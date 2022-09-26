package com.example.twilio_conversations

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.twilio.conversations.*
import com.twilio.conversations.extensions.getConversation
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
import java.time.format.DateTimeFormatter


/** TwilioConversationsPlugin */
class TwilioConversationsPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    public val TAG = TwilioConversationsPlugin::class.qualifiedName


    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var context: Context
    private lateinit var activity: Activity
    private var result: Result? = null

    private var conversationsClient: ConversationsClient? = null
    private var conversationsStreamHandler = TwilioConversationsStreamHandler()

    // The scope for the UI thread
    private val mainScope = CoroutineScope(Dispatchers.Main)

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
                ConversationsClient.create(context, token, props, mConversationsClientCallback)
            }
            "myConversations" -> {
                val conversations = emptyList<HashMap<String, Any?>>().toMutableList()
                conversationsClient?.myConversations?.forEach {
                    conversations += hashMapOf(
                        Pair("sid", it.sid),
                        Pair("friendlyName", it.friendlyName),
                        Pair("lastMessageDate", it.lastMessageDate?.toString()),
                        Pair("lastMessageIndex", it.lastMessageIndex)
                    )
                }

                result.success(conversations)
            }
            "getMessageByIndex" -> {
                val sid = call.argument<String>("sid") ?: ""
                val index = call.argument<Int>("index")

                mainScope.launch {
                    withContext(Dispatchers.IO) {
                        val conversation = conversationsClient?.getConversation(sid)
                        index?.let { index ->
                            conversation?.getMessageByIndex(
                                index.toLong(),
                                CallbackListener<Message>() {
                                    result.success(it.body)
                                })
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
                conversationsStreamHandler.sink?.success(hashMapOf<String, String?>("onConversationAdded" to conversation?.sid))
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

            }

            override fun onUserSubscribed(user: User?) {

            }

            override fun onUserUnsubscribed(user: User?) {

            }

            override fun onClientSynchronization(synchronizationStatus: ConversationsClient.SynchronizationStatus) {
                conversationsStreamHandler.sink?.success(hashMapOf<String, Int>("onClientSynchronization" to synchronizationStatus.value))
            }

            override fun onNewMessageNotification(
                conversationSid: String?,
                messageSid: String?,
                messageIndex: Long
            ) {

            }

            override fun onAddedToConversationNotification(conversationSid: String?) {
                conversationsStreamHandler.sink?.success(hashMapOf<String, String?>("onAddedToConversationNotification" to conversationSid))
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
}

package com.example.twilio_conversations

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.twilio.conversations.*
import com.twilio.util.ErrorInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


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

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "twilio_conversations")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
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
                val conversations = emptyList<String>().toMutableList()
                conversationsClient?.myConversations?.forEach {
                    conversations += it.friendlyName
                }

                result.success(conversations)
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
                // conversationsClient.addListener(this@TwilioConversationsPlugin.mConversationsClientListener)
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
                TODO("Not yet implemented")
            }

            override fun onConversationUpdated(
                conversation: Conversation?,
                reason: Conversation.UpdateReason?
            ) {
                TODO("Not yet implemented")
            }

            override fun onConversationDeleted(conversation: Conversation?) {
                TODO("Not yet implemented")
            }

            override fun onConversationSynchronizationChange(conversation: Conversation?) {
                TODO("Not yet implemented")
            }

            override fun onError(errorInfo: ErrorInfo?) {
                TODO("Not yet implemented")
            }

            override fun onUserUpdated(user: User?, reason: User.UpdateReason?) {
                TODO("Not yet implemented")
            }

            override fun onUserSubscribed(user: User?) {
                TODO("Not yet implemented")
            }

            override fun onUserUnsubscribed(user: User?) {
                TODO("Not yet implemented")
            }

            override fun onClientSynchronization(synchronizationStatus: ConversationsClient.SynchronizationStatus) {
                if (synchronizationStatus == ConversationsClient.SynchronizationStatus.COMPLETED) {
                    // loadChannels()
                }
            }

            override fun onNewMessageNotification(
                conversationSid: String?,
                messageSid: String?,
                messageIndex: Long
            ) {
                TODO("Not yet implemented")
            }

            override fun onAddedToConversationNotification(conversationSid: String?) {
                TODO("Not yet implemented")
            }

            override fun onRemovedFromConversationNotification(conversationSid: String?) {
                TODO("Not yet implemented")
            }

            override fun onNotificationSubscribed() {
                TODO("Not yet implemented")
            }

            override fun onNotificationFailed(errorInfo: ErrorInfo?) {
                TODO("Not yet implemented")
            }

            override fun onConnectionStateChange(state: ConversationsClient.ConnectionState?) {
                TODO("Not yet implemented")
            }

            override fun onTokenExpired() {
                TODO("Not yet implemented")
            }

            override fun onTokenAboutToExpire() {
                TODO("Not yet implemented")
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

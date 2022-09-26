package com.example.twilio_conversations

import io.flutter.plugin.common.EventChannel
import android.os.Handler
import android.os.Looper

class TwilioConversationsStreamHandler: EventChannel.StreamHandler {
    var sink: EventChannel.EventSink? = null
    var handler: Handler? = null

    private val runnable = Runnable {
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
        handler = Handler(Looper.getMainLooper())
        handler?.post(runnable)
    }

    override fun onCancel(arguments: Any?) {
        sink = null
        handler?.removeCallbacks(runnable)
    }
}
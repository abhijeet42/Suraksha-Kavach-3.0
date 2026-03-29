package com.example.suraksha_kavach

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.provider.Telephony
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val SMS_CHANNEL = "com.suraksha.kavach/sms_stream"
    private var smsReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    smsReceiver = createSmsReceiver(events)
                    val filter = IntentFilter(Telephony.Sms.Intents.SMS_RECEIVED_ACTION)
                    filter.priority = 999 // High priority
                    registerReceiver(smsReceiver, filter)
                }

                override fun onCancel(arguments: Any?) {
                    smsReceiver?.let {
                        unregisterReceiver(it)
                        smsReceiver = null
                    }
                }
            }
        )
    }

    private fun createSmsReceiver(events: EventChannel.EventSink): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
                    val smsMessages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
                    if (smsMessages != null && smsMessages.isNotEmpty()) {
                        
                        // OTPs and long messages are often sent as "multipart" SMS.
                        // We must concatenate all the parts into one single message body.
                        val sender = smsMessages[0]?.displayOriginatingAddress ?: "Unknown"
                        val fullMessage = StringBuilder()
                        
                        for (sms in smsMessages) {
                            sms?.displayMessageBody?.let {
                                fullMessage.append(it)
                            }
                        }
                        
                        val smsData = mapOf(
                            "sender" to sender,
                            "message" to fullMessage.toString(),
                            "timestamp" to System.currentTimeMillis()
                        )
                        events.success(smsData)
                    }
                }
            }
        }
    }
}

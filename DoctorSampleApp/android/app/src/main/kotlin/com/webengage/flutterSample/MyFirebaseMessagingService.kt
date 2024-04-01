package com.webengage.flutterSample
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage
import com.webengage.sdk.android.WebEngage;

class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onNewToken(s: String) {
        super.onNewToken(s)
        WebEngage.get().setRegistrationID(s)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        val data = remoteMessage.data
        if (data != null) {
            if (data.containsKey("source") && "webengage" == data["source"]) {
                WebEngage.get().receive(data)
            }
        }
    }
}
package com.webengage.webengage_plugin_example;

import android.util.Log;


import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.webengage.sdk.android.WebEngage;

import java.util.Map;

public class MyFirebaseMessagingService extends FirebaseMessagingService  {
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        Log.d("Webengage","Message received");
        Map<String, String> data = remoteMessage.getData();
        if(data != null) {
            if(data.containsKey("source") && "webengage".equals(data.get("source"))) {
                WebEngage.get().receive(data);
            }
        }
    }

    public void onNewToken(String s) {
        super.onNewToken(s);
        WebEngage.get().setRegistrationID(s);
    }
}

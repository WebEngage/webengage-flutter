package com.webengage.webengage_plugin;

import com.webengage.sdk.android.WebEngage;

public class WebengageInitializer {
    public static void initialize() {
        WebEngage.registerPushNotificationCallback(new FlutterPushMessageCallback());
    }
}

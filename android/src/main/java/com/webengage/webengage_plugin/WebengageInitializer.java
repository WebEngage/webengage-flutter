package com.webengage.webengage_plugin;

import android.app.Application;

import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import com.webengage.sdk.android.WebEngageConfig;
import com.webengage.sdk.android.callbacks.InAppNotificationCallbacks;

public class WebengageInitializer {
    public static void initialize(Application application, WebEngageConfig config) {
        WebEngage.registerPushNotificationCallback(new FlutterPushMessageCallback());
        WebEngage.registerInAppNotificationCallback(new FlutterInAppCallbacks());
        application.registerActivityLifecycleCallbacks(new WebEngageActivityLifeCycleCallbacks(application.getApplicationContext(), config));
    }
}

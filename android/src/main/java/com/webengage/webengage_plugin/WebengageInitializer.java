package com.webengage.webengage_plugin;

import android.app.Application;

import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import com.webengage.sdk.android.WebEngageConfig;

public class WebengageInitializer {
    public static void initialize(Application application, WebEngageConfig  config) {
        WebEngage.registerPushNotificationCallback(new FlutterPushMessageCallback());
        application.registerActivityLifecycleCallbacks(new WebEngageActivityLifeCycleCallbacks(application.getApplicationContext(),config));

    }
}

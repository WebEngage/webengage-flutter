// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

package com.webengage.webengage_plugin;

import android.app.Application;

import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import com.webengage.sdk.android.WebEngageConfig;
import com.webengage.sdk.android.callbacks.InAppNotificationCallbacks;

public class WebengageInitializer {

    /**
     *  This method initializes WebEngage integration within an Android application,
     *  registering callbacks for push notifications, in-app notifications,
     *  activity lifecycle, and state change events with corresponding Flutter callback handlers.
     */
    public static void initialize(Application application, WebEngageConfig config) {
        WebEngage.registerPushNotificationCallback(new FlutterPushMessageCallback());
        WebEngage.registerInAppNotificationCallback(new FlutterInAppCallbacks());
        WebEngage.registerWESecurityCallback(new FlutterSecurityCallback());
        application.registerActivityLifecycleCallbacks(new WebEngageActivityLifeCycleCallbacks(application.getApplicationContext(), config));
        WebEngage.registerStateChangeCallback(new WEFlutterStateChangedCallbacks());
    }

}

package com.webengage.webengage_plugin_example;

import android.content.Context;
import android.util.Log;


import com.webengage.sdk.android.LocationTrackingStrategy;
import com.webengage.sdk.android.PushUtils;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import com.webengage.sdk.android.WebEngageConfig;
import com.webengage.sdk.android.actions.render.InAppNotificationData;
import com.webengage.sdk.android.actions.render.PushNotificationData;
import com.webengage.sdk.android.callbacks.InAppNotificationCallbacks;
import com.webengage.sdk.android.callbacks.PushNotificationCallbacks;
import com.webengage.sdk.android.utils.Provider;
import com.webengage.webengage_plugin.WebEngagePlugin;
import com.webengage.webengage_plugin.WebengageInitializer;
import com.webengage.sdk.android.WebEngageConfig;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;

public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("webengage", "MainApplicationstarts");
        WebEngageConfig webEngageConfig = new WebEngageConfig.Builder()
                .setWebEngageKey("d3a4b5a9")
                .setAutoGCMRegistrationFlag(false)
                .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
                .setDebugMode(true) // only in development mode
                .setAutoGAIDTracking(true)
                .build();
        WebengageInitializer.initialize(this, webEngageConfig);

    }
}

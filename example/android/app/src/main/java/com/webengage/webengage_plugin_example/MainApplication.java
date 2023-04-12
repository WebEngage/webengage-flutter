package com.webengage.webengage_plugin_example;

import android.app.Application;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;
import com.webengage.sdk.android.LocationTrackingStrategy;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import com.webengage.sdk.android.WebEngageConfig;
import com.webengage.webengage_plugin.WebengageInitializer;
import io.flutter.app.FlutterApplication;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;
import com.google.firebase.messaging.FirebaseMessagingService;
public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("webengage", "MainApplicationstarts");
        WebEngageConfig webEngageConfig = new WebEngageConfig.Builder()
                .setWebEngageKey("~47b66161")
                .setAutoGCMRegistrationFlag(false)
                .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
                .setDebugMode(true) // only in development mode
                .build();
        WebengageInitializer.initialize((Application)this.getApplicationContext(), webEngageConfig);
        FirebaseMessaging.getInstance().getToken().addOnCompleteListener(new OnCompleteListener<String>() {
            @Override
            public void onComplete(@NonNull Task<String> task) {
                String token = task.getResult();
                Log.e("TAG", "onComplete: push token"+token);
                WebEngage.get().setRegistrationID(token);
            }
        });
    }
}

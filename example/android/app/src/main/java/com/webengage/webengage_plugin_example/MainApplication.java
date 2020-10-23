package com.webengage.webengage_plugin_example;

import android.content.Context;
import android.util.Log;

import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.InstanceIdResult;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import com.webengage.sdk.android.actions.render.PushNotificationData;
import com.webengage.sdk.android.callbacks.PushNotificationCallbacks;
import com.webengage.webengage_plugin.WebEngagePlugin;
import com.webengage.webengage_plugin.WebengageInitializer;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;

public class MainApplication extends FlutterApplication  {
    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("webengage","MainApplicationstarts");

        registerActivityLifecycleCallbacks(new WebEngageActivityLifeCycleCallbacks(this));
        FirebaseInstanceId.getInstance().getInstanceId().addOnSuccessListener(new OnSuccessListener<InstanceIdResult>() {
            @Override
            public void onSuccess(InstanceIdResult instanceIdResult) {
                String token = instanceIdResult.getToken();
                WebEngage.get().setRegistrationID(token);
            }
        });
        WebengageInitializer.initialize();
        WebEngage.registerPushNotificationCallback(new PushNotificationCallbacks() {
            @Override
            public PushNotificationData onPushNotificationReceived(Context context, PushNotificationData pushNotificationData) {
                Log.d("webengage","applicationonPushNotificationReceived");
                return pushNotificationData;
            }

            @Override
            public void onPushNotificationShown(Context context, PushNotificationData pushNotificationData) {

            }

            @Override
            public boolean onPushNotificationClicked(Context context, PushNotificationData pushNotificationData) {
                Log.d("webengage","applicationonPushNotificationClicked");

                return false;
            }

            @Override
            public void onPushNotificationDismissed(Context context, PushNotificationData pushNotificationData) {

            }

            @Override
            public boolean onPushNotificationActionClicked(Context context, PushNotificationData pushNotificationData, String s) {
                return false;
            }
        });
    }


}

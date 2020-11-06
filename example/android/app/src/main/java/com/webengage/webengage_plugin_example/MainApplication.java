package com.webengage.webengage_plugin_example;

import android.content.Context;
import android.util.Log;

import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.InstanceIdResult;
import com.webengage.sdk.android.LocationTrackingStrategy;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import com.webengage.sdk.android.WebEngageConfig;
import com.webengage.sdk.android.actions.render.InAppNotificationData;
import com.webengage.sdk.android.actions.render.PushNotificationData;
import com.webengage.sdk.android.callbacks.InAppNotificationCallbacks;
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
        WebEngageConfig webEngageConfig = new WebEngageConfig.Builder()
                .setWebEngageKey("YOUR_LICENCSE_CODE")
                .setAutoGCMRegistrationFlag(false)
                .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
                .setDebugMode(true) // only in development mode
                .build();
        WebengageInitializer.initialize(this,webEngageConfig);
        FirebaseInstanceId.getInstance().getInstanceId().addOnSuccessListener(new OnSuccessListener<InstanceIdResult>() {
            @Override
            public void onSuccess(InstanceIdResult instanceIdResult) {
                String token = instanceIdResult.getToken();
                WebEngage.get().setRegistrationID(token);
            }
        });
//        WebEngage.registerInAppNotificationCallback(new InAppNotificationCallbacks() {
//            @Override
//            public InAppNotificationData onInAppNotificationPrepared(Context context, InAppNotificationData inAppNotificationData) {
//                return null;
//            }
//
//            @Override
//            public void onInAppNotificationShown(Context context, InAppNotificationData inAppNotificationData) {
//
//            }
//
//            @Override
//            public boolean onInAppNotificationClicked(Context context, InAppNotificationData inAppNotificationData, String s) {
//                return false;
//            }
//
//            @Override
//            public void onInAppNotificationDismissed(Context context, InAppNotificationData inAppNotificationData) {
//
//            }
//        });
//        WebEngage.registerPushNotificationCallback(new PushNotificationCallbacks() {
//            @Override
//            public PushNotificationData onPushNotificationReceived(Context context, PushNotificationData pushNotificationData) {
//                Log.d("webengage","applicationonPushNotificationReceived");
//                return pushNotificationData;
//            }
//
//            @Override
//            public void onPushNotificationShown(Context context, PushNotificationData pushNotificationData) {
//
//            }
//
//            @Override
//            public boolean onPushNotificationClicked(Context context, PushNotificationData pushNotificationData) {
//                Log.d("webengage","applicationonPushNotificationClicked");
//
//                return false;
//            }
//
//            @Override
//            public void onPushNotificationDismissed(Context context, PushNotificationData pushNotificationData) {
//
//            }
//
//            @Override
//            public boolean onPushNotificationActionClicked(Context context, PushNotificationData pushNotificationData, String s) {
//                return false;
//            }
//        });
//
}


}

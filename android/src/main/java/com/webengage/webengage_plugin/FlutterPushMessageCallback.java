package com.webengage.webengage_plugin;

import android.content.Context;
import android.util.Log;

import com.webengage.sdk.android.actions.render.PushNotificationData;
import com.webengage.sdk.android.callbacks.PushNotificationCallbacks;

public class FlutterPushMessageCallback implements PushNotificationCallbacks {
    @Override
    public PushNotificationData onPushNotificationReceived(Context context, PushNotificationData pushNotificationData) {
        Log.d("webengae","pluginonPushNotificationReceived");

        return pushNotificationData;
    }

    @Override
    public void onPushNotificationShown(Context context, PushNotificationData pushNotificationData) {
        Log.d("webengae","pluginonPushNotificationShown");

    }

    @Override
    public boolean onPushNotificationClicked(Context context, PushNotificationData pushNotificationData) {
        Log.d("webengae","pluginonPushNotificationClicked");
        WebEngagePlugin.sendOrQueueCallback(Constants.METHOD_NAME_ON_PUSH_CLICK,
                Utils.bundleToMap(pushNotificationData.getCustomData()));
        return false;
    }

    @Override
    public void onPushNotificationDismissed(Context context, PushNotificationData pushNotificationData) {

    }

    @Override
    public boolean onPushNotificationActionClicked(Context context, PushNotificationData pushNotificationData, String s) {
        return false;
    }
}

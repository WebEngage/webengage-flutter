package com.webengage.webengage_plugin;

import android.content.Context;

import com.webengage.sdk.android.actions.render.InAppNotificationData;
import com.webengage.sdk.android.callbacks.InAppNotificationCallbacks;

import java.util.Map;

public class FlutterInAppCallbacks implements InAppNotificationCallbacks {
    @Override
    public InAppNotificationData onInAppNotificationPrepared(Context context, InAppNotificationData inAppNotificationData) {
        WebEngagePlugin.sendOrQueueCallback(Constants.METHOD_NAME_ON_INAPP_PREPARED,
                Utils.jsonObjectToMap(inAppNotificationData.getData()));
        return inAppNotificationData;
    }

    @Override
    public void onInAppNotificationShown(Context context, InAppNotificationData inAppNotificationData) {
        WebEngagePlugin.sendOrQueueCallback(Constants.METHOD_NAME_ON_INAPP_SHOWN,
                Utils.jsonObjectToMap(inAppNotificationData.getData()));
    }

    @Override
    public boolean onInAppNotificationClicked(Context context, InAppNotificationData inAppNotificationData, String s) {
        Map<String, Object> map = Utils.jsonObjectToMap(inAppNotificationData.getData());
        map.put("selectedActionId", s);
        WebEngagePlugin.sendOrQueueCallback(Constants.METHOD_NAME_ON_INAPP_CLICKED, map);
        return false;
    }

    @Override
    public void onInAppNotificationDismissed(Context context, InAppNotificationData inAppNotificationData) {
        WebEngagePlugin.sendOrQueueCallback(Constants.METHOD_NAME_ON_INAPP_DISMISS,
                Utils.jsonObjectToMap(inAppNotificationData.getData()));
    }
}

package com.webengage.webengage_plugin;

import android.content.Context;

import com.webengage.sdk.android.actions.render.PushNotificationData;
import com.webengage.sdk.android.callbacks.PushNotificationCallbacks;

import java.util.Map;

import static com.webengage.webengage_plugin.Constants.MethodName.*;


public class FlutterPushMessageCallback implements PushNotificationCallbacks {

    @Override
    public PushNotificationData onPushNotificationReceived(Context context, PushNotificationData pushNotificationData) {

        return pushNotificationData;
    }

    @Override
    public void onPushNotificationShown(Context context, PushNotificationData pushNotificationData) {

    }

    @Override
    public boolean onPushNotificationClicked(Context context, PushNotificationData pushNotificationData) {
        String uri = pushNotificationData.getPrimeCallToAction().getAction();
        Map<String, Object> map = Utils.bundleToMap(pushNotificationData.getCustomData());
        map.put("uri", uri);
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_PUSH_CLICK, map);

        return false;
    }

    @Override
    public void onPushNotificationDismissed(Context context, PushNotificationData pushNotificationData) {

    }

    @Override
    public boolean onPushNotificationActionClicked(Context context, PushNotificationData pushNotificationData, String s) {
        String uri = pushNotificationData.getCallToActionById(s).getAction();
        Map<String, Object> map = Utils.bundleToMap(pushNotificationData.getCustomData());
        map.put("uri", uri);
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_PUSH_ACTION_CLICK, map);
        return false;
    }

}

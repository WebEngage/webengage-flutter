// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.


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

    /**
     * Called when a push notification is clicked.
     *
     * @param context              The context associated with the callback.
     * @param pushNotificationData The data of the push notification that was clicked.
     * @return true if the click event is consumed, false otherwise.
     */
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

    /**
     * Called when an action associated with a push notification is clicked.
     *
     * @param context              The context associated with the callback.
     * @param pushNotificationData The data of the push notification containing the action.
     * @param actionId             The ID of the action that was clicked.
     * @return true if the action click event is consumed, false otherwise.
     */
    @Override
    public boolean onPushNotificationActionClicked(Context context, PushNotificationData pushNotificationData, String s) {
        String uri = pushNotificationData.getCallToActionById(s).getAction();
        Map<String, Object> map = Utils.bundleToMap(pushNotificationData.getCustomData());
        map.put("uri", uri);
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_PUSH_ACTION_CLICK, map);
        return false;
    }

}

// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

package com.webengage.webengage_plugin;

import android.content.Context;

import com.webengage.sdk.android.actions.render.InAppNotificationData;
import com.webengage.sdk.android.callbacks.InAppNotificationCallbacks;

import java.util.Map;

import static com.webengage.webengage_plugin.Constants.ARGS.SELECTED_ACTION_ID;
import static com.webengage.webengage_plugin.Constants.MethodName.*;


public class FlutterInAppCallbacks implements InAppNotificationCallbacks {


    /**
     * Called when an in-app notification is prepared for display.
     *
     * @param context              The context associated with the callback.
     * @param inAppNotificationData The data of the in-app notification being prepared.
     * @return The prepared in-app notification data.
     */
    @Override
    public InAppNotificationData onInAppNotificationPrepared(Context context, InAppNotificationData inAppNotificationData) {
       WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_INAPP_PREPARED,
                Utils.jsonObjectToMap(inAppNotificationData.getData()));
        return inAppNotificationData;
    }

    /**
     * Called when an in-app notification is shown to the user.
     *
     * @param context              The context associated with the callback.
     * @param inAppNotificationData The data of the in-app notification being shown.
     */
    @Override
    public void onInAppNotificationShown(Context context, InAppNotificationData inAppNotificationData) {
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_INAPP_SHOWN,
                Utils.jsonObjectToMap(inAppNotificationData.getData()));
    }

    /**
     * Called when an action associated with an in-app notification is clicked.
     *
     * @param context              The context associated with the callback.
     * @param inAppNotificationData The data of the in-app notification containing the action.
     * @param actionId             The ID of the action that was clicked.
     * @return true if the action click event is consumed, false otherwise.
     */
    @Override
    public boolean onInAppNotificationClicked(Context context, InAppNotificationData inAppNotificationData, String s) {
        Map<String, Object> map = Utils.jsonObjectToMap(inAppNotificationData.getData());
        map.put(SELECTED_ACTION_ID, s);
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_INAPP_CLICKED, map);
        return false;
    }

    /**
     * Called when an in-app notification is dismissed.
     *
     * @param context              The context associated with the callback.
     * @param inAppNotificationData The data of the dismissed in-app notification.
     */
    @Override
    public void onInAppNotificationDismissed(Context context, InAppNotificationData inAppNotificationData) {
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_INAPP_DISMISS,
                Utils.jsonObjectToMap(inAppNotificationData.getData()));
    }
}

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


    @Override
    public InAppNotificationData onInAppNotificationPrepared(Context context, InAppNotificationData inAppNotificationData) {
       WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_INAPP_PREPARED,
                Utils.jsonObjectToMap(inAppNotificationData.getData()));
        return inAppNotificationData;
    }

    @Override
    public void onInAppNotificationShown(Context context, InAppNotificationData inAppNotificationData) {
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_INAPP_SHOWN,
                Utils.jsonObjectToMap(inAppNotificationData.getData()));
    }

    @Override
    public boolean onInAppNotificationClicked(Context context, InAppNotificationData inAppNotificationData, String s) {
        Map<String, Object> map = Utils.jsonObjectToMap(inAppNotificationData.getData());
        map.put(SELECTED_ACTION_ID, s);
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_INAPP_CLICKED, map);
        return false;
    }

    @Override
    public void onInAppNotificationDismissed(Context context, InAppNotificationData inAppNotificationData) {
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_INAPP_DISMISS,
                Utils.jsonObjectToMap(inAppNotificationData.getData()));
    }
}

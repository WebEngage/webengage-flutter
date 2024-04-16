// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

package com.webengage.webengage_plugin;

import static com.webengage.webengage_plugin.Constants.ARGS.ANONYMOUS_USER_ID;
import static com.webengage.webengage_plugin.Constants.MethodName.METHOD_NAME_ON_ANONYMOUS_ID_CHANGED;

import android.content.Context;

import com.webengage.sdk.android.callbacks.StateChangeCallbacks;

import java.util.HashMap;
import java.util.Map;

//weflutter
public class WEFlutterStateChangedCallbacks extends StateChangeCallbacks {

    @Override
    public void onAnonymousIdChanged(Context context, String anonymousUserID) {
        super.onAnonymousIdChanged(context, anonymousUserID);
        Map<String, Object> map = new HashMap<>();
        map.put(ANONYMOUS_USER_ID, anonymousUserID);
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_ANONYMOUS_ID_CHANGED,map);
    }


}
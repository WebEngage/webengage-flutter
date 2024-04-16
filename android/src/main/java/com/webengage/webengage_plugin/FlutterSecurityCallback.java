// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.


package com.webengage.webengage_plugin;

import static com.webengage.webengage_plugin.Constants.MethodName.METHOD_NAME_ON_INAPP_PREPARED;
import static com.webengage.webengage_plugin.Constants.MethodName.METHOD_NAME_ON_TOKEN_INVALIDATED;
import com.webengage.sdk.android.callbacks.WESecurityCallback;

import java.util.Map;

public class FlutterSecurityCallback implements WESecurityCallback {
    @Override
    public void onSecurityException(Map<String, Object> map) {
        WECallbackRegistry.getInstance().passCallback(METHOD_NAME_ON_TOKEN_INVALIDATED, map);
    }
}

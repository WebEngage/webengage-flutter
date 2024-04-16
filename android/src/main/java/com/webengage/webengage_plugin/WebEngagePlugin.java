// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

package com.webengage.webengage_plugin;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.webengage.sdk.android.Channel;
import com.webengage.sdk.android.Logger;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.actions.render.PushNotificationData;
import com.webengage.sdk.android.utils.Gender;

import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import static com.webengage.webengage_plugin.Constants.ARGS.*;

import static com.webengage.webengage_plugin.Constants.MethodName.*;
import static com.webengage.webengage_plugin.Constants.PARAM.*;
import static com.webengage.webengage_plugin.Constants.WEBENGAGE_PLUGIN;

/** WebEngage Plugin */
public class WebEngagePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, WESendOrQueueCallbackListener {
    private static final String TAG = "WebEngagePlugin";

    private MethodChannel channel;
    private Context context;
    Activity activity;
    private static boolean isInitialised;

    private static final Map<String, Map<String, Object>> messageQueue =
            Collections.synchronizedMap(new LinkedHashMap<String, Map<String, Object>>());


    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        Log.w(TAG, "onAttachedToEngine on thread: " + Thread.currentThread().getName());
        this.context = flutterPluginBinding.getApplicationContext();
        init(flutterPluginBinding.getBinaryMessenger());
    }

    /**
     * This method sets up a communication channel between the plugin and Flutter engine,
     * allowing them to exchange messages.
     */
    private void init(BinaryMessenger binaryMessenger) {
        channel = new MethodChannel(binaryMessenger, WEBENGAGE_PLUGIN);
        channel.setMethodCallHandler(this);
    }

    /**
     * Call different cases depending on the data sent from the Flutter end.
     */
    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case METHOD_NAME_SET_USER_LOGIN:
                userLogin(call, result);
                break;

            case METHOD_NAME_SET_USER_LOGIN_WITH_SECURE_TOKEN:
                userLoginWithSecureToken(call, result);
               break;

            case METHOD_NAME_SET_SECURE_TOKEN:
                setSecureToken(call, result);
                break;

            case METHOD_NAME_SET_USER_LOGOUT:
                userLogout();
                break;


            case METHOD_NAME_SET_USER_FIRST_NAME:
                setUserFirstName(call, result);
                break;


            case METHOD_NAME_SET_USER_LAST_NAME:
                setUserLastName(call, result);
                break;


            case METHOD_NAME_SET_USER_EMAIL:
                setUserEmail(call, result);
                break;


            case METHOD_NAME_SET_USER_HASHED_EMAIL:
                setUserHashedEmail(call, result);
                break;


            case METHOD_NAME_SET_USER_PHONE:
                setUserPhone(call, result);
                break;


            case METHOD_NAME_SET_USER_HASHED_PHONE:
                setUserHashedPhone(call, result);
                break;

            case METHOD_NAME_SET_USER_COMPANY:
                setUserCompany(call, result);
                break;


            case METHOD_NAME_SET_USER_BIRTHDATE:
                setUserBirthDate(call, result);
                break;


            case METHOD_NAME_SET_USER_GENDER:
                setUserGender(call, result);
                break;


            case METHOD_NAME_SET_USER_OPT_IN: {
                setUserOptIn(call, result);
                break;
            }

            case METHOD_NAME_SET_USER_LOCATION:
                setUserLocation(call, result);
                break;


            case METHOD_NAME_TRACK_EVENT:
                trackEvent(call, result);
                break;


            case METHOD_NAME_TRACK_SCREEN:
                trackScreen(call, result);
                break;

            case METHOD_NAME_INITIALISE:
                onInitialised();
                break;

            case METHOD_NAME_SET_USER_ATTRIBUTE:
                setUserAttribute(call, result);
                break;

            case METHOD_NAME_SET_USER_STRING_ATTRIBUTE:
                setUserStringAttribute(call, result);
                break;

            case METHOD_NAME_SET_USER_INT_ATTRIBUTE:
                setUserIntAttribute(call, result);
                break;

            case METHOD_NAME_SET_USER_DOUBLE_ATTRIBUTE:
                setUserDoubleAttribute(call, result);
                break;

            case METHOD_NAME_SET_USER_BOOL_ATTRIBUTE:
                setUserBoolAttribute(call, result);
                break;

            case METHOD_NAME_SET_USER_DATE_ATTRIBUTE:
                setUserDateAttribute(call, result);
                break;

            case METHOD_NAME_SET_USER_MAP_ATTRIBUTE:
                setUserMapAttribute(call, result);
                break;

            case METHOD_NAME_SET_USER_LIST_ATTRIBUTE:
                setUserListAttribute(call, result);
                break;

            case METHOD_NAME_SET_USER_DEVICE_PUSH_OPT_IN:
                setDevicePushOptIn(call, result);
                break;

            case METHOD_NAME_START_GAID_TRACKING :
                startGAIDTracking();
                break;
            default:
                result.notImplemented();

        }
    }

    /**
     * This private method sets user attributes using data provided in the method call
     *  from Flutter using the WebEngage SDK.
     */
    private void setUserMapAttribute(MethodCall call, Result result) {
        Map<String, ? extends Object> attributes = call.argument(ATTRIBUTES);
        WebEngage.get().user().setAttributes(attributes);
    }

    /**
     *  This method sets user attributes based on the type of data received from the Flutter end.
     *  Depending on the data type (String, Integer, Double/Float, Date, List, Boolean),
     *  it sets the corresponding attribute using the WebEngage SDK.
     *  If the data type is not supported, it logs a message indicating so.
     */
    private void setUserAttribute(MethodCall call, Result result) {
        if (call.argument(ATTRIBUTES) instanceof String) {
            String attributeName = call.argument(ATTRIBUTE_NAME);
            String attributes = call.argument(ATTRIBUTES);
            WebEngage.get().user().setAttribute(attributeName, attributes);
        } else if (call.argument(ATTRIBUTES) instanceof Integer) {
            String attributeName = call.argument(ATTRIBUTE_NAME);
            int attributes = call.argument(ATTRIBUTES);
            WebEngage.get().user().setAttribute(attributeName, attributes);
        } else if (call.argument(ATTRIBUTES) instanceof Double || call.argument(ATTRIBUTES) instanceof Float) {
            String attributeName = call.argument(ATTRIBUTE_NAME);
            double attributes = call.argument(ATTRIBUTES);
            WebEngage.get().user().setAttribute(attributeName, attributes);
        } else if (call.argument(ATTRIBUTES) instanceof Date) {
            String attributeName = call.argument(ATTRIBUTE_NAME);
            Date attributes = call.argument(ATTRIBUTES);
            WebEngage.get().user().setAttribute(attributeName, attributes);
        } else if (call.argument(ATTRIBUTES) instanceof List) {
            String attributeName = call.argument(ATTRIBUTE_NAME);
            List<? extends Object> attributes = call.argument(ATTRIBUTES);
            WebEngage.get().user().setAttribute(attributeName, attributes);
        } else if (call.argument(ATTRIBUTES) instanceof Boolean) {
            String attributeName = call.argument(ATTRIBUTE_NAME);
            Boolean attributes = call.argument(ATTRIBUTES);
            WebEngage.get().user().setAttribute(attributeName, attributes);
        } else {
            Log.d("webengage", "No other type supported");
        }

    }

    private void setUserListAttribute(MethodCall call, Result result) {
        String attributeName = call.argument(ATTRIBUTE_NAME);
        List<? extends Object> attributes = call.argument(ATTRIBUTES);
        WebEngage.get().user().setAttribute(attributeName, attributes);
    }

    private void setUserDateAttribute(MethodCall call, Result result) {
        String attributeName = call.argument(ATTRIBUTE_NAME);
        Date attributes = call.argument(ATTRIBUTES);
        WebEngage.get().user().setAttribute(attributeName, attributes);
    }

    private void setUserBoolAttribute(MethodCall call, Result result) {
        String attributeName = call.argument(ATTRIBUTE_NAME);
        Boolean attributes = call.argument(ATTRIBUTES);
        WebEngage.get().user().setAttribute(attributeName, attributes);
    }

    private void setUserDoubleAttribute(MethodCall call, Result result) {
        String attributeName = call.argument(ATTRIBUTE_NAME);
        double attributes = call.argument(ATTRIBUTES);
        WebEngage.get().user().setAttribute(attributeName, attributes);
    }

    private void setUserIntAttribute(MethodCall call, Result result) {
        String attributeName = call.argument(ATTRIBUTE_NAME);
        int attributes = call.argument(ATTRIBUTES);
        WebEngage.get().user().setAttribute(attributeName, attributes);
    }

    private void setUserStringAttribute(MethodCall call, Result result) {
        String attributeName = call.argument(ATTRIBUTE_NAME);
        String attributes = call.argument(ATTRIBUTES);
        WebEngage.get().user().setAttribute(attributeName, attributes);
    }

    private void onInitialised() {
        isInitialised = true;
        synchronized (messageQueue) {
            // Handle all the messages received before the Dart isolate was
            // initialized, then clear the queue.
            for (Map.Entry<String, Map<String, Object>> entry : messageQueue.entrySet()) {
                sendCallback(entry.getKey(), entry.getValue());
            }
            messageQueue.clear();
        }
    }

    /**
     *  This method handles user login by extracting the user ID from the method call arguments
     *  received from Flutter and then initiates a login action using the WebEngage SDK.
     */
    private void userLogin(MethodCall call, Result result) {
        String userId = call.arguments();
        WebEngage.get().user().login(userId);
    }

    /**
     *  This method facilitates user login with a secure token by extracting the user ID and
     *  secure token from the method call arguments received from Flutter.
     *  It then initiates a login action using the WebEngage SDK,
     *  considering whether a secure token is provided.
     *  If a secure token is provided and not empty,
     *  it uses both the user ID and secure token for login; otherwise,
     *  it proceeds with only the user ID for login.
     */
    private void userLoginWithSecureToken(MethodCall call, Result result) {
        Map<String, Object> arguments = call.arguments();
        String userId = (String) arguments.get(USER_ID);
        String secureToken = (String) arguments.get(SECURE_TOKEN);
        if (secureToken != null && !secureToken.isEmpty()) {
            WebEngage.get().user().login(userId, secureToken);
        } else {
            WebEngage.get().user().login(userId);
        }
    }

    public void setSecureToken(MethodCall call, Result result) {
        Map<String, Object> arguments = call.arguments();
        String userId = (String) arguments.get(USER_ID);
        String secureToken = (String) arguments.get(SECURE_TOKEN);
        if(!userId.isEmpty() && userId != null && !secureToken.isEmpty() && secureToken != null) {
            WebEngage.get().setSecurityToken(userId, secureToken);
        }
    }

    private void setDevicePushOptIn(MethodCall call, Result result) {
        Boolean status = call.arguments();
        WebEngage.get().user().setDevicePushOptIn(status);
    }

    private void userLogout() {
        WebEngage.get().user().logout();
    }

    private void setUserFirstName(MethodCall call, Result result) {
        String firstName = call.arguments();
        WebEngage.get().user().setFirstName(firstName);
    }

    private void setUserLastName(MethodCall call, Result result) {
        String lastName = call.arguments();
        WebEngage.get().user().setLastName(lastName);
    }

    private void setUserEmail(MethodCall call, Result result) {
        String email = call.arguments();
        WebEngage.get().user().setEmail(email);
    }

    private void setUserHashedEmail(MethodCall call, Result result) {
        String hashedEmail = call.arguments();
        WebEngage.get().user().setHashedEmail(hashedEmail);
    }

    private void setUserPhone(MethodCall call, Result result) {
        String phone = call.arguments();
        WebEngage.get().user().setPhoneNumber(phone);
    }

    private void setUserHashedPhone(MethodCall call, Result result) {
        String hashedPhone = call.arguments();
        WebEngage.get().user().setHashedPhoneNumber(hashedPhone);
    }

    private void setUserCompany(MethodCall call, Result result) {
        String company = call.arguments();
        WebEngage.get().user().setCompany(company);
    }

    private void setUserBirthDate(MethodCall call, Result result) {
        String birthDate = call.arguments();
        WebEngage.get().user().setBirthDate(birthDate);
    }

    private void setUserGender(MethodCall call, Result result) {
        String gender = call.arguments();
        if (MALE.equalsIgnoreCase(gender)) {
            WebEngage.get().user().setGender(Gender.MALE);
        } else if (FEMALE.equalsIgnoreCase(gender)) {
            WebEngage.get().user().setGender(Gender.FEMALE);
        } else if (OTHER.equalsIgnoreCase(gender)) {
            WebEngage.get().user().setGender(Gender.OTHER);
        }
    }

    private void setUserOptIn(MethodCall call, Result result) {
        String channel = call.argument(CHANNEL);
        boolean status = call.argument(OPTIN);
        if (PUSH.equalsIgnoreCase(channel)) {
            WebEngage.get().user().setOptIn(Channel.PUSH, status);
        } else if (SMS.equalsIgnoreCase(channel)) {
            WebEngage.get().user().setOptIn(Channel.SMS, status);
        } else if (EMAIL.equalsIgnoreCase(channel)) {
            WebEngage.get().user().setOptIn(Channel.EMAIL, status);
        } else if (IN_APP.equalsIgnoreCase(channel)) {
            WebEngage.get().user().setOptIn(Channel.IN_APP, status);
        } else if (WHATSAPP.equalsIgnoreCase(channel)) {
            WebEngage.get().user().setOptIn(Channel.WHATSAPP, status);
        } else if (VIBER.equalsIgnoreCase(channel)) {
            WebEngage.get().user().setOptIn(Channel.VIBER, status);
        }
        else {
            result.error(TAG, "Invalid channel: " + channel + ". Must be one of [push, sms, email, in_app, whatsapp].", null);
        }
    }

    private void setUserLocation(MethodCall call, Result result) {
        double lat = call.argument(LAT);
        double lng = call.argument(LNG);
        WebEngage.get().user().setLocation(lat, lng);
    }

    private void trackEvent(MethodCall call, Result result) {
        String eventName = call.argument(EVENT_NAME);
        Map<String, Object> attributes = call.argument(ATTRIBUTES);
        WebEngage.get().analytics().track(eventName, attributes);
    }

    private void trackScreen(MethodCall call, Result result) {
        String screenName = call.argument(SCREEN_NAME);
        Map<String, Object> screenData = call.argument(SCREEN_DATA);
        if (screenData == null)
            WebEngage.get().analytics().screenNavigated(screenName);
        else
            WebEngage.get().analytics().screenNavigated(screenName, screenData);

    }

    private void startGAIDTracking(){
        WebEngage.get().startGAIDTracking();
    }

    /**
     * This method handles the detachment of the Flutter plugin from the engine by
     * resetting relevant variables and releasing resources associated with the communication channel.
     */
    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        isInitialised = false;
        channel.setMethodCallHandler(null);
        channel = null;

    }


    private void invokeMethodOnUiThread(String methodName, PushNotificationData pushNotificationData) {
        final MethodChannel channel = this.channel;
        runOnMainThread(() -> channel.invokeMethod(methodName, bundleToMap(pushNotificationData.getCustomData())));
    }

    @Override
    public void sendOrQueueCallback(String methodName, Map<String, Object> message) {
        if (isInitialised) {
            sendCallback(methodName, message);
        } else {
            messageQueue.put(methodName, message);
        }
    }

    /**
     *  This method sends a callback message to Flutter,
     *  packaging it with necessary platform information,
     *  using a background thread to ensure UI responsiveness and avoiding potential crashes due
     *  to null channel during transition from background to foreground state
     */
    void sendCallback(final String methodName, final Map<String, Object> message) {
        if (channel == null)
            return;
        final Map<String, Object> messagePayload = new HashMap<>();
        messagePayload.put(PARAM_PLATFORM, PARAM_PLATFORM_VALUE);
        messagePayload.put(PARAM_PAYLOAD, message);
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                // If the null check is not handled here, it can cause a crash when transitioning from the background to foreground state in a very rare case.
                if (channel != null) {
                    channel.invokeMethod(methodName, messagePayload);
                }
            }
        });
    }

    Map<String, Object> bundleToMap(Bundle extras) {
        Map<String, Object> map = new HashMap<>();

        Set<String> ks = extras.keySet();
        for (String key : ks) {
            map.put(key, extras.get(key));
        }
        return map;
    }

    private void runOnMainThread(final Runnable runnable) {
        if (activity != null) {
            activity.runOnUiThread(runnable);
        } else {
            try {
                ((Activity) context).runOnUiThread(runnable);
            } catch (Exception e) {
                Log.e(TAG, "Exception while running on main thread - ");
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        WECallbackRegistry.getInstance().register(this);
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        WECallbackRegistry.getInstance().unRegister(this);
        activity = null;
    }
}

package com.webengage.webengage_plugin;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.IntDef;
import androidx.annotation.NonNull;

import com.webengage.sdk.android.Channel;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.actions.render.PushNotificationData;
import com.webengage.sdk.android.callbacks.PushNotificationCallbacks;
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
import io.flutter.plugin.common.PluginRegistry;

import static com.webengage.webengage_plugin.Constants.ARGS.*;
import static com.webengage.webengage_plugin.Constants.MethodName.*;
import static com.webengage.webengage_plugin.Constants.PARAM.*;
import static com.webengage.webengage_plugin.Constants.WEBENGAGE_PLUGIN;


public class WebEngagePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static final String TAG = "WebEngagePlugin";

    private static MethodChannel channel;
    private Context context;
    Activity activity;
    private static boolean isInitialised;
    private static final Map<String, Map<String, Object>> messageQueue =
            Collections.synchronizedMap(new LinkedHashMap<String, Map<String, Object>>());

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        Log.w(TAG, "onAttachedToEngine on thread: " + Thread.currentThread().getName());
        if(channel == null) {
            channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), WEBENGAGE_PLUGIN);
            channel.setMethodCallHandler(this);
            this.context = flutterPluginBinding.getApplicationContext();
        }
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case METHOD_NAME_SET_USER_LOGIN:
                userLogin(call, result);
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
            default:
                result.notImplemented();

        }
    }

    private void setUserMapAttribute(MethodCall call, Result result) {
        Map<String, ? extends Object> attributes = call.argument(ATTRIBUTES);
        WebEngage.get().user().setAttributes(attributes);
    }

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

    private void userLogin(MethodCall call, Result result) {
        String userId = call.arguments();
        WebEngage.get().user().login(userId);
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
        } else {
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

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        isInitialised = false;
        channel.setMethodCallHandler(null);
    }


    private void invokeMethodOnUiThread(String methodName, PushNotificationData pushNotificationData) {
        final MethodChannel channel = this.channel;
        runOnMainThread(() -> channel.invokeMethod(methodName, bundleToMap(pushNotificationData.getCustomData())));
    }

    static void sendOrQueueCallback(String methodName, Map<String, Object> message) {
        if (isInitialised) {
            sendCallback(methodName, message);
        } else {
            messageQueue.put(methodName, message);
        }
    }

    static void sendCallback(final String methodName, final Map<String, Object> message) {
        final Map<String, Object> messagePayload = new HashMap<>();
        messagePayload.put(PARAM_PLATFORM, PARAM_PLATFORM_VALUE);
        messagePayload.put(PARAM_PAYLOAD, message);
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                channel.invokeMethod(methodName, messagePayload);
            }
        });
    }

    static Map<String, Object> bundleToMap(Bundle extras) {
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
        activity = null;
    }
}

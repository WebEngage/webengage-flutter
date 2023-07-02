package com.webengage.webengage_plugin;

import static com.webengage.webengage_plugin.Constants.ARGS.*;
import static com.webengage.webengage_plugin.Constants.MethodName.*;
import static com.webengage.webengage_plugin.Constants.PARAM.*;
import static com.webengage.webengage_plugin.Constants.WEBENGAGE_PLUGIN;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;
import com.google.android.gms.tasks.Tasks;
import com.webengage.sdk.android.Channel;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.actions.render.PushNotificationData;
import com.webengage.sdk.android.utils.Gender;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

public class WebEngagePlugin
        implements
        FlutterPlugin,
        MethodCallHandler,
        ActivityAware,
        WESendOrQueueCallbackListener {

    private static final String TAG = "WebEngagePlugin";

    private MethodChannel channel;
    Activity activity;
    private static boolean isInitialised;

    private static final Map<String, Map<String, Object>> messageQueue = Collections.synchronizedMap(
            new LinkedHashMap<String, Map<String, Object>>()
    );

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        Log.w(TAG, "onAttachedToEngine on thread: " + Thread.currentThread().getName());
        init(flutterPluginBinding.getBinaryMessenger());
    }

    private void init(BinaryMessenger binaryMessenger) {
        channel = new MethodChannel(binaryMessenger, WEBENGAGE_PLUGIN);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        Task<?> methodCallTask = null;

        switch (call.method) {
            case METHOD_NAME_SET_USER_LOGIN:
                methodCallTask = userLogin(call.arguments());
                break;
            case METHOD_NAME_SET_USER_LOGOUT:
                methodCallTask = userLogout();
                break;
            case METHOD_NAME_SET_USER_FIRST_NAME:
                methodCallTask = setUserFirstName(call.arguments());
                break;
            case METHOD_NAME_SET_USER_LAST_NAME:
                methodCallTask = setUserLastName(call.arguments());
                break;
            case METHOD_NAME_SET_USER_EMAIL:
                methodCallTask = setUserEmail(call.arguments());
                break;
            case METHOD_NAME_SET_USER_HASHED_EMAIL:
                methodCallTask = setUserHashedEmail(call.arguments());
                break;
            case METHOD_NAME_SET_USER_PHONE:
                methodCallTask = setUserPhone(call.arguments());
                break;
            case METHOD_NAME_SET_USER_HASHED_PHONE:
                methodCallTask = setUserHashedPhone(call.arguments());
                break;
            case METHOD_NAME_SET_USER_COMPANY:
                methodCallTask = setUserCompany(call.arguments());
                break;
            case METHOD_NAME_SET_USER_BIRTHDATE:
                methodCallTask = setUserBirthDate(call.arguments());
                break;
            case METHOD_NAME_SET_USER_GENDER:
                methodCallTask = setUserGender(call.arguments());
                break;
            case METHOD_NAME_SET_USER_OPT_IN:
                methodCallTask =
                        setUserOptIn(call.argument(CHANNEL), call.argument(OPTIN));
                break;
            case METHOD_NAME_SET_USER_LOCATION:
                methodCallTask =
                        setUserLocation(call.argument(LAT), call.argument(LNG));
                break;
            case METHOD_NAME_TRACK_EVENT:
                methodCallTask =
                        trackEvent(call.argument(EVENT_NAME), call.argument(ATTRIBUTES));
                break;
            case METHOD_NAME_TRACK_SCREEN:
                methodCallTask =
                        trackScreen(call.argument(SCREEN_NAME), call.argument(SCREEN_DATA));
                break;
            case METHOD_NAME_INITIALISE:
                methodCallTask = onInitialised();
                break;
            case METHOD_NAME_SET_USER_ATTRIBUTE:
                methodCallTask =
                        setUserAttribute(
                                call.argument(ATTRIBUTE_NAME),
                                call.argument(ATTRIBUTES)
                        );
                break;
            case METHOD_NAME_SET_USER_STRING_ATTRIBUTE:
                methodCallTask =
                        setUserStringAttribute(
                                call.argument(ATTRIBUTE_NAME),
                                call.argument(ATTRIBUTES)
                        );
                break;
            case METHOD_NAME_SET_USER_INT_ATTRIBUTE:
                methodCallTask =
                        setUserIntAttribute(
                                call.argument(ATTRIBUTE_NAME),
                                call.argument(ATTRIBUTES)
                        );
                break;
            case METHOD_NAME_SET_USER_DOUBLE_ATTRIBUTE:
                methodCallTask =
                        setUserDoubleAttribute(
                                call.argument(ATTRIBUTE_NAME),
                                call.argument(ATTRIBUTES)
                        );
                break;
            case METHOD_NAME_SET_USER_BOOL_ATTRIBUTE:
                methodCallTask =
                        setUserBoolAttribute(
                                call.argument(ATTRIBUTE_NAME),
                                call.argument(ATTRIBUTES)
                        );
                break;
            case METHOD_NAME_SET_USER_DATE_ATTRIBUTE:
                methodCallTask =
                        setUserDateAttribute(
                                call.argument(ATTRIBUTE_NAME),
                                call.argument(ATTRIBUTES)
                        );
                break;
            case METHOD_NAME_SET_USER_MAP_ATTRIBUTE:
                methodCallTask = setUserMapAttribute(call.argument(ATTRIBUTES));
                break;
            case METHOD_NAME_SET_USER_LIST_ATTRIBUTE:
                methodCallTask =
                        setUserListAttribute(
                                call.argument(ATTRIBUTE_NAME),
                                call.argument(ATTRIBUTES)
                        );
                break;
            case METHOD_NAME_SET_USER_DEVICE_PUSH_OPT_IN:
                methodCallTask = setDevicePushOptIn(call.arguments());
                break;
            default:
                result.notImplemented();
                return;
        }

        methodCallTask.addOnCompleteListener((e) -> {
            if (e.isSuccessful()) {
                result.success(null);
            } else {
                result.error(TAG, "Error occured while invocaing" + channel.toString(), Objects.requireNonNull(e.getException()).toString());
            }
        });

    }

    private Task<Void> setUserMapAttribute(
            Map<String, ? > attributes
    ) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setAttributes(attributes);
            taskCompletionSource.setResult(null);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserAttribute(String attributeName, Object attributes) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        boolean isValidAttribute = true;

        if (attributes instanceof String) {
            WebEngage.get().user().setAttribute(attributeName, (String) attributes);
        } else if (attributes instanceof Double || attributes instanceof Float || attributes instanceof Integer ) {
            WebEngage.get().user().setAttribute(attributeName, (Number) attributes);
        } else if (attributes instanceof Date) {
            WebEngage.get().user().setAttribute(attributeName, (Date) attributes);
        } else if (attributes instanceof List) {
            WebEngage.get().user().setAttribute(attributeName, (List<?>) attributes);
        } else if (attributes instanceof Boolean) {
            WebEngage.get().user().setAttribute(attributeName, (Boolean) attributes);
        } else {
            isValidAttribute = false;
        }

        if (isValidAttribute) {
            taskCompletionSource.setResult(null);
        } else {
            taskCompletionSource.setException(
                    new Exception(
                            (attributes != null ? attributes.toString() : null) +
                                    "is not supported type"
                    )
            );
        }

        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserListAttribute(
            String attributeName,
            List<?> attributes
    ) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setAttribute(attributeName, attributes);
            taskCompletionSource.setResult(null);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserDateAttribute(
            String attributeName,
            Date attributes
    ) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        WebEngage.get().user().setAttribute(attributeName, attributes);
        try {
            taskCompletionSource.setResult(null);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserBoolAttribute(
            String attributeName,
            Boolean attributes
    ) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        WebEngage.get().user().setAttribute(attributeName, attributes);
        try {
            taskCompletionSource.setResult(null);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserDoubleAttribute(
            String attributeName,
            double attributes
    ) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        WebEngage.get().user().setAttribute(attributeName, attributes);
        try {
            taskCompletionSource.setResult(null);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserIntAttribute(String attributeName, int attributes) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        WebEngage.get().user().setAttribute(attributeName, attributes);
        try {
            taskCompletionSource.setResult(null);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserStringAttribute(
            String attributeName,
            String attributes
    ) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        WebEngage.get().user().setAttribute(attributeName, attributes);
        try {
            taskCompletionSource.setResult(null);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> onInitialised() {
        isInitialised = true;
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        synchronized (messageQueue) {
            // Handle all the messages received before the Dart isolate was
            // initialized, then clear the queue.
            try {
                for (Map.Entry<String, Map<String, Object>> entry : messageQueue.entrySet()) {
                    sendCallback(entry.getKey(), entry.getValue());
                }
                messageQueue.clear();
                taskCompletionSource.setResult(null);
            } catch (Exception e) {
                taskCompletionSource.setException(e);
            }
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> userLogin(String userId) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().login(userId);
            taskCompletionSource.setResult(null);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> setDevicePushOptIn(Boolean status) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setDevicePushOptIn(status);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        taskCompletionSource.setResult(null);
        return taskCompletionSource.getTask();
    }

    private Task<Void> userLogout() {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().logout();
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        taskCompletionSource.setResult(null);
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserFirstName(String firstName) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setFirstName(firstName);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        taskCompletionSource.setResult(null);
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserLastName(String lastName) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setLastName(lastName);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        taskCompletionSource.setResult(null);
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserEmail(String email) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setEmail(email);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        taskCompletionSource.setResult(null);
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserHashedEmail(String hashedEmail) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setHashedEmail(hashedEmail);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        taskCompletionSource.setResult(null);
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserPhone(String phone) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setPhoneNumber(phone);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        taskCompletionSource.setResult(null);
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserHashedPhone(String hashedPhone) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setHashedPhoneNumber(hashedPhone);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        taskCompletionSource.setResult(null);
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserCompany(String company) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setCompany(company);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        taskCompletionSource.setResult(null);
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserBirthDate(String birthDate) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setBirthDate(birthDate);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        taskCompletionSource.setResult(null);
        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserGender(String gender) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        boolean isAValidGender = true;

        switch (gender.toLowerCase()) {
            case MALE:
                WebEngage.get().user().setGender(Gender.MALE);
                break;
            case FEMALE:
                WebEngage.get().user().setGender(Gender.FEMALE);
                break;
            case OTHER:
                WebEngage.get().user().setGender(Gender.OTHER);
                break;
            default:
                isAValidGender = false;
        }

        if (isAValidGender) {
            taskCompletionSource.setResult(null);
        } else {
            taskCompletionSource.setException(
                    new Exception(gender + "is not a valid gender")
            );
        }

        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserOptIn(String channel, boolean status) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        boolean isValidChannel = true;

        switch (channel.toLowerCase()) {
            case PUSH:
                WebEngage.get().user().setOptIn(Channel.PUSH, status);
                break;
            case SMS:
                WebEngage.get().user().setOptIn(Channel.SMS, status);
                break;
            case EMAIL:
                WebEngage.get().user().setOptIn(Channel.EMAIL, status);
                break;
            case IN_APP:
                WebEngage.get().user().setOptIn(Channel.IN_APP, status);
                break;
            case WHATSAPP:
                WebEngage.get().user().setOptIn(Channel.WHATSAPP, status);
                break;
            default:
                isValidChannel = false;
        }

        if (isValidChannel) {
            taskCompletionSource.setResult(null);
        } else {
            taskCompletionSource.setException(
                    new Exception(channel.toString() + "is not a valid channel")
            );
        }

        return taskCompletionSource.getTask();
    }

    private Task<Void> setUserLocation(double lat, double lng) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().user().setLocation(lat, lng);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> trackEvent(
            String eventName,
            Map<String, Object> attributes
    ) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            WebEngage.get().analytics().track(eventName, attributes);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    private Task<Void> trackScreen(
            String screenName,
            Map<String, Object> screenData
    ) {
        TaskCompletionSource<Void> taskCompletionSource = new TaskCompletionSource<>();
        try {
            if (screenData == null) WebEngage
                    .get()
                    .analytics()
                    .screenNavigated(screenName);
            else WebEngage
                    .get()
                    .analytics()
                    .screenNavigated(screenName, screenData);
            taskCompletionSource.setResult(null);
        } catch (Exception e) {
            taskCompletionSource.setException(e);
        }
        return taskCompletionSource.getTask();
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        isInitialised = false;
        channel.setMethodCallHandler(null);
        channel = null;
    }

    @Override
    public void sendOrQueueCallback(
            String methodName,
            Map<String, Object> message
    ) {
        if (isInitialised) {
            sendCallback(methodName, message);
        } else {
            messageQueue.put(methodName, message);
        }
    }

    void sendCallback(
            final String methodName,
            final Map<String, Object> message
    ) {
        if (channel == null) return;
        final Map<String, Object> messagePayload = new HashMap<>();
        messagePayload.put(PARAM_PLATFORM, PARAM_PLATFORM_VALUE);
        messagePayload.put(PARAM_PAYLOAD, message);
        new Handler(Looper.getMainLooper())
                .post(
                        new Runnable() {
                            @Override
                            public void run() {
                                channel.invokeMethod(methodName, messagePayload);
                            }
                        }
                );
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        android.util.Log.e(TAG, "onAttachedToActivity: ");
        WECallbackRegistry.getInstance().register(this);
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(
            @NonNull ActivityPluginBinding binding
    ) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        WECallbackRegistry.getInstance().unRegister(this);
        activity = null;
    }
}

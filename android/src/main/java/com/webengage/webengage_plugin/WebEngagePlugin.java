package com.webengage.webengage_plugin;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.webengage.sdk.android.Channel;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.actions.render.PushNotificationData;
import com.webengage.sdk.android.callbacks.PushNotificationCallbacks;
import com.webengage.sdk.android.utils.Gender;

import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
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

import static com.webengage.webengage_plugin.Constants.METHOD_NAME_INITIALISE;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_BIRTHDATE;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_COMPANY;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_EMAIL;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_FIRST_NAME;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_GENDER;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_HASHED_EMAIL;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_HASHED_PHONE;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_LAST_NAME;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_LOCATION;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_LOGIN;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_LOGOUT;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_OPT_IN;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_SET_USER_PHONE;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_TRACK_EVENT;
import static com.webengage.webengage_plugin.Constants.METHOD_NAME_TRACK_SCREEN;

public class WebEngagePlugin implements FlutterPlugin, MethodCallHandler,ActivityAware {
  private static final String TAG = "WebEngagePlugin";

  private static MethodChannel channel;
  private Context context;
  Activity activity;
  private static boolean isInitialised;
  private static final Map<String, Map<String, Object>> messageQueue =
          Collections.synchronizedMap(new LinkedHashMap<String, Map<String, Object>>());
  public WebEngagePlugin() {
    Log.w(TAG, "Constructor called on thread: " + Thread.currentThread().getName());
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
    Log.w(TAG, "onAttachedToEngine on thread: " + Thread.currentThread().getName());
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "webengage_plugin");
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
    //WebEngage.registerPushNotificationCallback(this);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case METHOD_NAME_SET_USER_LOGIN: {
        userLogin(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_LOGOUT: {
        userLogout();
        break;
      }

      case METHOD_NAME_SET_USER_FIRST_NAME: {
        setUserFirstName(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_LAST_NAME: {
        setUserLastName(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_EMAIL: {
        setUserEmail(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_HASHED_EMAIL: {
        setUserHashedEmail(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_PHONE: {
        setUserPhone(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_HASHED_PHONE: {
        setUserHashedPhone(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_COMPANY: {
        setUserCompany(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_BIRTHDATE: {
        setUserBirthDate(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_GENDER: {
        setUserGender(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_OPT_IN: {
        setUserOptIn(call, result);
        break;
      }

      case METHOD_NAME_SET_USER_LOCATION: {
        setUserLocation(call, result);
        break;
      }

      case METHOD_NAME_TRACK_EVENT: {
        trackEvent(call, result);
        break;
      }

      case METHOD_NAME_TRACK_SCREEN: {
        trackScreen(call, result);
        break;
      }
      case METHOD_NAME_INITIALISE: {
        onInitialised();
        break;
      }
    }

    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  private void onInitialised() {
    Log.v("webengage" , " onInitialised() : MoEngage Flutter plugin initialised.");
    Log.v("webengage" ,  " onInitialised() : Message queue: " + messageQueue);
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
    if ("male".equalsIgnoreCase(gender)) {
      WebEngage.get().user().setGender(Gender.MALE);
    } else if ("female".equalsIgnoreCase(gender)) {
      WebEngage.get().user().setGender(Gender.FEMALE);
    } else if ("other".equalsIgnoreCase(gender)) {
      WebEngage.get().user().setGender(Gender.OTHER);
    }
  }

  private void setUserOptIn(MethodCall call, Result result) {
    String channel = call.argument("channel");
    boolean status = call.argument("optIn");
    if ("push".equalsIgnoreCase(channel)) {
      WebEngage.get().user().setOptIn(Channel.PUSH, status);
    } else if ("sms".equalsIgnoreCase(channel)) {
      WebEngage.get().user().setOptIn(Channel.SMS, status);
    } else if ("email".equalsIgnoreCase(channel)) {
      WebEngage.get().user().setOptIn(Channel.EMAIL, status);
    } else if ("in_app".equalsIgnoreCase(channel)) {
      WebEngage.get().user().setOptIn(Channel.IN_APP, status);
    } else if ("whatsapp".equalsIgnoreCase(channel)) {
      WebEngage.get().user().setOptIn(Channel.WHATSAPP, status);
    } else {
      result.error(TAG, "Invalid channel: " + channel + ". Must be one of [push, sms, email, in_app, whatsapp].", null);
    }
  }

  private void setUserLocation(MethodCall call, Result result) {
    double lat = call.argument("lat");
    double lng = call.argument("lng");
    WebEngage.get().user().setLocation(lat, lng);
  }

  private void trackEvent(MethodCall call, Result result) {
    String eventName = call.argument("eventName");
    Map<String, Object> attributes = call.argument("attributes");
    WebEngage.get().analytics().track(eventName, attributes);
  }

  private void trackScreen(MethodCall call, Result result) {
    String screenName = call.argument("screenName");
    WebEngage.get().analytics().screenNavigated(screenName);
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  public static void registerWith(PluginRegistry.Registrar registrar) {

    WebEngagePlugin plugin = new WebEngagePlugin();
    plugin.setupPlugin(registrar.context(), null, registrar);
  }
  private void setupPlugin(Context context, BinaryMessenger messenger, PluginRegistry.Registrar registrar) {

    if (registrar != null) {
      //V1 setup
      this.channel = new MethodChannel(registrar.messenger(), "webengage_plugin");
      this.activity = ((Activity) registrar.activeContext());
    } else {
      //V2 setup
      this.channel = new MethodChannel(messenger, "webengage_plugin");
    }
    this.channel.setMethodCallHandler(this);
    this.context = context.getApplicationContext();

  }
private void invokeMethodOnUiThread(String methodName, PushNotificationData pushNotificationData) {

  final MethodChannel channel = this.channel;
  runOnMainThread(() -> channel.invokeMethod(methodName, bundleToMap(pushNotificationData.getCustomData())));
}

  static void sendOrQueueCallback(String methodName, Map<String, Object> message) {
    if (isInitialised) {
      Log.v("Webengage" , " sendOrQueueCallback() : Flutter Engine initialised will send message");
      sendCallback(methodName, message);
    } else {
      Log.v("Webengage", " sendOrQueueCallback() : Flutter Engine not initialised adding message to "
              + "queue");
      messageQueue.put(methodName, message);
    }
  }
  static void  sendCallback(final String methodName, final Map<String, Object> message){
    final Map<String, Object> messagePayload = new HashMap<>();
    messagePayload.put(Constants.PARAM_PLATFORM, Constants.PARAM_PLATFORM_VALUE);
    messagePayload.put(Constants.PARAM_PAYLOAD, message);
    new Handler(Looper.getMainLooper()).post(new Runnable() {
      @Override public void run() {
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

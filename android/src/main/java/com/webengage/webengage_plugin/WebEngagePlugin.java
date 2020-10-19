package com.webengage.webengage_plugin;

import android.content.Context;
import android.util.Log;

import com.webengage.sdk.android.Channel;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.utils.Gender;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class WebEngagePlugin implements FlutterPlugin, MethodCallHandler {
  private static final String TAG = "WebEngagePlugin";

  private MethodChannel channel;
  private Context context;

  public WebEngagePlugin() {
    Log.w(TAG, "Constructor called on thread: " + Thread.currentThread().getName());
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
    Log.w(TAG, "onAttachedToEngine on thread: " + Thread.currentThread().getName());
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "webengage_plugin");
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "userLogin": {
        userLogin(call, result);
        break;
      }

      case "userLogout": {
        userLogout();
        break;
      }

      case "setUserFirstName": {
        setUserFirstName(call, result);
        break;
      }

      case "setUserLastName": {
        setUserLastName(call, result);
        break;
      }

      case "setUserEmail": {
        setUserEmail(call, result);
        break;
      }

      case "setUserHashedEmail": {
        setUserHashedEmail(call, result);
        break;
      }

      case "setUserPhone": {
        setUserPhone(call, result);
        break;
      }

      case "setUserHashedPhone": {
        setUserHashedPhone(call, result);
        break;
      }

      case "setUserCompany": {
        setUserCompany(call, result);
        break;
      }

      case "setUserBirthDate": {
        setUserBirthDate(call, result);
        break;
      }

      case "setUserGender": {
        setUserGender(call, result);
        break;
      }

      case "setUserOptIn": {
        setUserOptIn(call, result);
        break;
      }

      case "setUserLocation": {
        setUserLocation(call, result);
        break;
      }

      case "trackEvent": {
        trackEvent(call, result);
        break;
      }

      case "trackScreen": {
        trackScreen(call, result);
        break;
      }
    }

    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
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
}

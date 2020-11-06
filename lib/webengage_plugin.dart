import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Constants.dart';
import 'dart:io' show Platform;

typedef void MessageHandler(Map<String, dynamic> message);
typedef void MessageHandlerInAppClick(Map<String, dynamic> message, String s);
typedef void MessageHandlerPushClick(Map<String, dynamic> message, String s);

class WebEngagePlugin {
  static const MethodChannel _channel = const MethodChannel('webengage_plugin');
  static final WebEngagePlugin _webengagePlugin =
      new WebEngagePlugin._internal();

  factory WebEngagePlugin() => _webengagePlugin;

  WebEngagePlugin._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
    _channel.invokeMethod(methodInitialise);
  }

  MessageHandlerPushClick _onPushClick;
  MessageHandlerPushClick _onPushActionClick;
  MessageHandlerInAppClick _onInAppClick;
  MessageHandler _onInAppShown;
  MessageHandler _onInAppDismiss;
  MessageHandler _onInAppPrepared;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  void setUpPushCallbacks(MessageHandlerPushClick onPushClick,
      MessageHandlerPushClick onPushActionClick) {
    _onPushClick = onPushClick;
    _onPushActionClick = onPushActionClick;
  }

  void setUpInAppCallbacks(
      MessageHandlerInAppClick onInAppClick,
      MessageHandler onInAppShown,
      MessageHandler onInAppDismiss,
      MessageHandler onInAppPrepared) {
    _onInAppClick = onInAppClick;
    _onInAppShown = onInAppShown;
    _onInAppDismiss = onInAppDismiss;
    _onInAppPrepared = onInAppPrepared;
  }

  static Future<void> userLogin(String userId) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_LOGIN, userId);
  }

  static Future<void> userLogout() async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_LOGOUT);
  }

  static Future<void> setUserFirstName(String firstName) async {
    return await _channel.invokeMethod(
        METHOD_NAME_SET_USER_FIRST_NAME, firstName);
  }

  static Future<void> setUserLastName(String lastName) async {
    return await _channel.invokeMethod(
        METHOD_NAME_SET_USER_LAST_NAME, lastName);
  }

  static Future<void> setUserEmail(String email) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_EMAIL, email);
  }

  static Future<void> setUserHashedEmail(String email) async {
    return await _channel.invokeMethod(
        METHOD_NAME_SET_USER_HASHED_EMAIL, email);
  }

  static Future<void> setUserPhone(String phone) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_PHONE, phone);
  }

  static Future<void> setUserHashedPhone(String phone) async {
    return await _channel.invokeMethod(
        METHOD_NAME_SET_USER_HASHED_PHONE, phone);
  }

  static Future<void> setUserCompany(String company) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_COMPANY, company);
  }

  static Future<void> setUserBirthDate(String birthDate) async {
    return await _channel.invokeMethod(
        METHOD_NAME_SET_USER_BIRTHDATE, birthDate);
  }

  static Future<void> setUserGender(String gender) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_GENDER, gender);
  }

  static Future<void> setUserOptIn(String channel, bool optIn) async {
    return await _channel.invokeMethod(
        METHOD_NAME_SET_USER_OPT_IN, {CHANNEL: channel, OPTIN: optIn});
  }

  static Future<void> setUserLocation(double lat, double lng) async {
    return await _channel
        .invokeMethod(METHOD_NAME_SET_USER_LOCATION, {LAT: lat, LNG: lng});
  }

  static Future<void> trackEvent(String eventName,
      [Map<String, dynamic> attributes]) async {
    return await _channel.invokeMethod(METHOD_NAME_TRACK_EVENT,
        {EVENT_NAME: eventName, ATTRIBUTES: attributes});
  }

  static Future<void> setUserAttributes(Map userAttributeValue) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_MAP_ATTRIBUTE,
        {ATTRIBUTE_NAME: "attributeName", ATTRIBUTES: userAttributeValue});
  }

  static Future<void> setUserAttribute(
      String attributeName, dynamic userAttributeValue) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_ATTRIBUTE,
        {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
  }

  static Future<void> trackScreen(String eventName,
      [Map<String, dynamic> screenData]) async {
    return await _channel.invokeMethod(METHOD_NAME_TRACK_SCREEN,
        {SCREEN_NAME: eventName, SCREEN_DATA: screenData});
  }

  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call ${call.method} ${call.arguments}");
    if (call.method == callbackOnPushClick && _onPushClick != null) {
      Map<String, dynamic> message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        String deeplink = message[PAYLOAD][URI];
        _onPushClick(message[PAYLOAD], deeplink);
      } else {
        String deeplink = message[DEEPLINK];
        _onPushClick(call.arguments.cast<String, dynamic>(), deeplink);
      }
    }
    if (call.method == callbackOnPushActionClick &&
        _onPushActionClick != null) {
      Map<String, dynamic> message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        String deeplink = message[PAYLOAD][URI];
        _onPushActionClick(message[PAYLOAD], deeplink);
      } else {
        String deeplink = message[DEEPLINK];
        _onPushActionClick(call.arguments.cast<String, dynamic>(), deeplink);
      }
    }
    if (call.method == callbackOnInAppClicked && _onInAppClick != null) {
      Map<String, dynamic> message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        String selectedActionId = message[PAYLOAD][SELECTED_ACTION_ID];
        Map<String, dynamic> newPayload = message[PAYLOAD].cast<String, dynamic>();
        _onInAppClick(newPayload, selectedActionId);
      } else {
        String selectedActionId = message[SELECTED_ACTION_ID];
        _onInAppClick(call.arguments.cast<String, dynamic>(), selectedActionId);
      }
    }
    if (call.method == callbackOnInAppShown && _onInAppShown != null) {
      Map<String, dynamic> message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        Map<String, dynamic> newPayload = message[PAYLOAD].cast<String, dynamic>();
        _onInAppShown(newPayload);
      } else {
        _onInAppShown(call.arguments.cast<String, dynamic>());
      }
    }
    if (call.method == callbackOnInAppDismissed && _onInAppDismiss != null) {
      Map<String, dynamic> message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        Map<String, dynamic> newPayload = message[PAYLOAD].cast<String, dynamic>();
        _onInAppDismiss(newPayload);
      } else {
        _onInAppDismiss(call.arguments.cast<String, dynamic>());
      }
    }
    if (call.method == callbackOnInAppPrepared && _onInAppPrepared != null) {

      Map<String, dynamic> message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        Map<String, dynamic> newPayload = message[PAYLOAD].cast<String, dynamic>();
        _onInAppPrepared(newPayload);
      } else {
        _onInAppPrepared(call.arguments.cast<String, dynamic>());
      }
    }
  }
}

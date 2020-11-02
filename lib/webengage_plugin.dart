import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Constants.dart';

typedef void MessageHandler(Map<String, dynamic> message);
typedef void MessageHandlerInAppClick(Map<String, dynamic> message, String s);

class WebEngagePlugin {
  static const MethodChannel _channel = const MethodChannel('webengage_plugin');
  static final WebEngagePlugin _webengagePlugin =
      new WebEngagePlugin._internal();

  factory WebEngagePlugin() => _webengagePlugin;

  WebEngagePlugin._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
    _channel.invokeMethod(methodInitialise);
  }

  MessageHandler _onPushClick;
  MessageHandlerInAppClick _onInAppClick;
  MessageHandler _onInAppShown;
  MessageHandler _onInAppDismiss;
  MessageHandler _onInAppPrepared;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  void setUpPushCallbacks(MessageHandler onPushClick) {
    print("_onPushClick != null initialised");

    _onPushClick = onPushClick;
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
    // return await _channel.invokeMethod(
    //     METHOD_NAME_SET_USER_ATTRIBUTE, {'attributeName': attributeName, 'attributes': attributes});
    if (attributeName.isEmpty) {
      if (userAttributeValue is Map) {
        return await _channel.invokeMethod(METHOD_NAME_SET_USER_MAP_ATTRIBUTE,
            {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
      }
      return;
    }

    if (userAttributeValue is String) {
      return await _channel.invokeMethod(METHOD_NAME_SET_USER_STRING_ATTRIBUTE,
          {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
    } else if (userAttributeValue is int) {
      return await _channel.invokeMethod(METHOD_NAME_SET_USER_INT_ATTRIBUTE,
          {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
    } else if (userAttributeValue is double) {
      return await _channel.invokeMethod(METHOD_NAME_SET_USER_DOUBLE_ATTRIBUTE,
          {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
    } else if (userAttributeValue is bool) {
      return await _channel.invokeMethod(METHOD_NAME_SET_USER_BOOL_ATTRIBUTE,
          {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
    } else if (userAttributeValue is DateTime) {
      return await _channel.invokeMethod(METHOD_NAME_SET_USER_DATE_ATTRIBUTE,
          {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
    } else if (userAttributeValue is List) {
      return await _channel.invokeMethod(METHOD_NAME_SET_USER_LIST_ATTRIBUTE,
          {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
    } else {
      print(
          "Only String, Numbers and Bool values supported as User Attributes");
    }
  }

  static Future<void> trackScreen(String eventName,
      [Map<String, dynamic> screenData]) async {
    return await _channel.invokeMethod(METHOD_NAME_TRACK_SCREEN,
        {SCREEN_NAME: eventName, SCREEN_DATA: screenData});
  }

  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call");

    print("_platformCallHandler call ${call.method} ${call.arguments}");
    if (call.method == callbackOnPushClick && _onPushClick != null) {
      print("Received callback in dart. Payload" + call.toString());

      _onPushClick(call.arguments.cast<String, dynamic>());
    }
    if (call.method == callbackOnInAppClicked && _onInAppClick != null) {
      print("Received callback in dart. PayloadcallbackOnInAppClicked" +
          call.toString());
      Map<String, dynamic> message = call.arguments.cast<String, dynamic>();
      print("Received callback in dart. message" + message.toString());

      String s = message["payload"]["selectedActionId"];
      print("Received callback in dart. selectedActionId" + s.toString());

      _onInAppClick(call.arguments.cast<String, dynamic>(), s);
    }
    if (call.method == callbackOnInAppShown && _onInAppShown != null) {
      print("Received callback in dart. Payload" + call.toString());

      _onInAppShown(call.arguments.cast<String, dynamic>());
    }
    if (call.method == callbackOnInAppDismissed && _onInAppDismiss != null) {
      print("Received callback in dart. Payload" + call.toString());

      _onInAppDismiss(call.arguments.cast<String, dynamic>());
    }
    if (call.method == callbackOnInAppPrepared && _onInAppPrepared != null) {
      print("Received callback in dart. Payload" + call.toString());

      _onInAppPrepared(call.arguments.cast<String, dynamic>());
    }
  }
}

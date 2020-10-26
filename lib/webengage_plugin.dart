import 'dart:async';

import 'package:flutter/services.dart';

import 'Constants.dart';
typedef void MessageHandler(Map<String, dynamic> message);

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
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  void setUpPushCallbacks(MessageHandler onPushClick) {
    print("_onPushClick != null initialised");

    _onPushClick = onPushClick;
  }

  static Future<void> userLogin(String userId) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_LOGIN, userId);
  }

  static Future<void> userLogout() async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_LOGOUT);
  }

  static Future<void> setUserFirstName(String firstName) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_FIRST_NAME, firstName);
  }

  static Future<void> setUserLastName(String lastName) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_LAST_NAME, lastName);
  }

  static Future<void> setUserEmail(String email) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_EMAIL, email);
  }

  static Future<void> setUserHashedEmail(String email) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_HASHED_EMAIL, email);
  }

  static Future<void> setUserPhone(String phone) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_PHONE, phone);
  }

  static Future<void> setUserHashedPhone(String phone) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_HASHED_PHONE, phone);
  }

  static Future<void> setUserCompany(String company) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_COMPANY, company);
  }

  static Future<void> setUserBirthDate(String birthDate) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_BIRTHDATE, birthDate);
  }

  static Future<void> setUserGender(String gender) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_GENDER, gender);
  }

  static Future<void> setUserOptIn(String channel, bool optIn) async {
    return await _channel
        .invokeMethod(METHOD_NAME_SET_USER_OPT_IN, {'channel': channel, 'optIn': optIn});
  }

  static Future<void> setUserLocation(double lat, double lng) async {
    return await _channel
        .invokeMethod(METHOD_NAME_SET_USER_LOCATION, {'lat': lat, 'lng': lng});
  }

  static Future<void> trackEvent(String eventName,
      [Map<String, dynamic> attributes]) async {
    return await _channel.invokeMethod(
        METHOD_NAME_TRACK_EVENT, {'eventName': eventName, 'attributes': attributes});
  }

  static Future<void> trackScreen(String eventName,
      [Map<String, dynamic> screenData]) async {
    return await _channel.invokeMethod(
        METHOD_NAME_TRACK_SCREEN, {'screenName': eventName, 'screenData': screenData});
  }

  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call");

    print("_platformCallHandler call ${call.method} ${call.arguments}");
    if (call.method == callbackOnPushClick && _onPushClick != null) {
      print("Received callback in dart. Payload" + call.toString());

      _onPushClick(call.arguments.cast<String, dynamic>());
    }
  }


}

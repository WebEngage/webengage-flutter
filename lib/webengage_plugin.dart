import 'dart:async';

import 'package:flutter/services.dart';

import 'Constants.dart';
typedef void CleverTapPushClickedPayloadReceivedHandler(Map<String, dynamic> map);
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

  CleverTapPushClickedPayloadReceivedHandler cleverTapPushClickedPayloadReceivedHandler;
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
    return await _channel.invokeMethod('userLogin', userId);
  }

  static Future<void> userLogout() async {
    return await _channel.invokeMethod('userLogout');
  }

  static Future<void> setUserFirstName(String firstName) async {
    return await _channel.invokeMethod('setUserFirstName', firstName);
  }

  static Future<void> setUserLastName(String lastName) async {
    return await _channel.invokeMethod('setUserLastName', lastName);
  }

  static Future<void> setUserEmail(String email) async {
    return await _channel.invokeMethod('setUserEmail', email);
  }

  static Future<void> setUserHashedEmail(String email) async {
    return await _channel.invokeMethod('setUserHashedEmail', email);
  }

  static Future<void> setUserPhone(String phone) async {
    return await _channel.invokeMethod('setUserPhone', phone);
  }

  static Future<void> setUserHashedPhone(String phone) async {
    return await _channel.invokeMethod('setUserHashedPhone', phone);
  }

  static Future<void> setUserCompany(String company) async {
    return await _channel.invokeMethod('setUserCompany', company);
  }

  static Future<void> setUserBirthDate(String birthDate) async {
    return await _channel.invokeMethod('setUserBirthDate', birthDate);
  }

  static Future<void> setUserGender(String gender) async {
    return await _channel.invokeMethod('setUserGender', gender);
  }

  static Future<void> setUserOptIn(String channel, bool optIn) async {
    return await _channel
        .invokeMethod('setUserOptIn', {'channel': channel, 'optIn': optIn});
  }

  static Future<void> setUserLocation(double lat, double lng) async {
    return await _channel
        .invokeMethod('setUserLocation', {'lat': lat, 'lng': lng});
  }

  static Future<void> trackEvent(String eventName,
      [Map<String, dynamic> attributes]) async {
    return await _channel.invokeMethod(
        'trackEvent', {'eventName': eventName, 'attributes': attributes});
  }

  static Future<void> trackScreen(String eventName,
      [Map<String, dynamic> screenData]) async {
    return await _channel.invokeMethod(
        'trackScreen', {'screenName': eventName, 'screenData': screenData});
  }

  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call");

    print("_platformCallHandler call ${call.method} ${call.arguments}");
    // switch (call.method) {
    //   case "onPushClick":
    //     Map<dynamic, dynamic> args = call.arguments;
    //     cleverTapPushClickedPayloadReceivedHandler(
    //         args.cast<String, dynamic>());
    //     break;
    // }
    if (call.method == callbackOnPushClick) {
      print("call.method == callbackOnPushClick");

    }
    else
      {
        print("call.method != callbackOnPushClick");

      }
    if (_onPushClick != null) {
      print("_onPushClick != null");

    }
    else
    {
      print("_onPushClick == null");

    }
    if (call.method == callbackOnPushClick && _onPushClick != null) {
      print("Received callback in dart. Payload" + call.toString());

      _onPushClick(call.arguments.cast<String, dynamic>());
    }
  }
    void setCleverTapPushClickedPayloadReceivedHandler(
        CleverTapPushClickedPayloadReceivedHandler handler) =>
        cleverTapPushClickedPayloadReceivedHandler = handler;

}

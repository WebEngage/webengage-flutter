import 'dart:async';

import 'package:flutter/services.dart';

class WebEngagePlugin {
  static const MethodChannel _channel = const MethodChannel('webengage_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
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

  static Future<void> setUserPhone(String email) async {
    return await _channel.invokeMethod('setUserPhone', email);
  }

  static Future<void> setUserHashedPhone(String email) async {
    return await _channel.invokeMethod('setUserHashedPhone', email);
  }

  static Future<void> setUserCompany(String email) async {
    return await _channel.invokeMethod('setUserCompany', email);
  }

  static Future<void> setUserBirthDate(String email) async {
    return await _channel.invokeMethod('setUserBirthDate', email);
  }

  static Future<void> setUserGender(String email) async {
    return await _channel.invokeMethod('setUserGender', email);
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
}

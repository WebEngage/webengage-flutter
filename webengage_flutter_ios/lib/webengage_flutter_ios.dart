import 'dart:async';

import 'package:flutter/services.dart' hide MessageHandler;
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

import 'src/we_extension/we_extension.dart';

class WEFlutterIos extends WEMethodChannel {
  static void registerWith() {
    WEPlatformInterface.instance = WEFlutterIos();
  }

  @override
  void init() {
    methodChannel.setMethodCallHandler(platformCallHandler);
    methodChannel.invokeMethod(methodInitialise);
  }

  @override
  Future<void> platformCallHandler(MethodCall call) {
    WELogger.w("platformCallHandler ${call.method}");
    switch (call.method) {
      case callbackOnPushClick:
      case callbackOnPushActionClick:
        handlePushClick(call);
        break;

      case callbackOnInAppClicked:
        handleInAppClick(call);
        break;

      case callbackOnInAppShown:
        handleCallbackFunctions(call, onInAppShown);
        break;

      case callbackOnInAppDismissed:
        handleCallbackFunctions(call, onInAppDismiss);
        break;

      case callbackOnInAppPrepared:
        handleCallbackFunctions(call, onInAppPrepared);
        break;

      case callbackOnTokenInvalidated:
        handleCallbackFunctions(call, onTokenInvalidated);
        break;

      case callbackOnAnonymousIdChanged:
        onAnonymousIdChanged(call);
        break;

      case METHOD_TRACK_DEEPLINK_URL:
        trackDeeplinkCallback(call);
        break;
    }
    return Future.value();
  }

  @override
  Future<void> setSecureToken(String userId, String secureToken) async {
    return await super.setSecureToken(userId, secureToken);
  }

  @override
  void setUpInAppCallbacks(
      MessageHandlerInAppClick onInAppClick,
      MessageHandler onInAppShown,
      MessageHandler onInAppDismiss,
      MessageHandler onInAppPrepared) {
    super.setUpInAppCallbacks(
        onInAppClick, onInAppShown, onInAppDismiss, onInAppPrepared);
  }

  @override
  void setUpPushCallbacks(MessageHandlerPushClick onPushClick,
      MessageHandlerPushClick onPushActionClick) {
    super.setUpPushCallbacks(onPushClick, onPushActionClick);
  }

  @override
  Future<void> setUserAttribute(
      String attributeName, userAttributeValue) async {
    return await super.setUserAttribute(attributeName, userAttributeValue);
  }

  @override
  Future<void> setUserAttributes(Map userAttributeValue) async {
    return await super.setUserAttributes(userAttributeValue);
  }

  @override
  Future<void> setUserBirthDate(String birthDate) async {
    return await super.setUserBirthDate(birthDate);
  }

  @override
  Future<void> setUserCompany(String company) async {
    return await super.setUserCompany(company);
  }

  @override
  Future<void> setUserDevicePushOptIn(bool status) async {
    return await super.setUserDevicePushOptIn(status);
  }

  @override
  Future<void> setUserEmail(String email) async {
    return await super.setUserEmail(email);
  }

  @override
  Future<void> setUserFirstName(String firstName) async {
    return await super.setUserFirstName(firstName);
  }

  @override
  Future<void> setUserGender(String gender) async {
    return await super.setUserGender(gender);
  }

  @override
  Future<void> setUserHashedEmail(String email) async {
    return await super.setUserHashedEmail(email);
  }

  @override
  Future<void> setUserHashedPhone(String phone) async {
    return await super.setUserHashedPhone(phone);
  }

  @override
  Future<void> setUserLastName(String lastName) async {
    return await super.setUserLastName(lastName);
  }

  @override
  Future<void> setUserLocation(double lat, double lng) async {
    return await super.setUserLocation(lat, lng);
  }

  @override
  Future<void> setUserOptIn(String channel, bool optIn) async {
    return await super.setUserOptIn(channel, optIn);
  }

  @override
  Future<void> setUserPhone(String phone) async {
    return await super.setUserPhone(phone);
  }

  @override
  Future<void> startGAIDTracking() async {
    return await methodChannel.invokeMethod(METHOD_NAME_START_GAID_TRACKING);
  }

  @override
  void tokenInvalidatedCallback(MessageHandler onTokenInvalidated) {
    super.tokenInvalidatedCallback(onTokenInvalidated);
  }

  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? attributes]) async {
    return await super.trackEvent(eventName, attributes);
  }

  @override
  Future<void> trackScreen(String screenName,
      [Map<String, dynamic>? screenData]) async {
    return await super.trackScreen(screenName, screenData);
  }

  @override
  Future<void> userLogin(String userId, [String? secureToken]) async {
    return await super.userLogin(userId, secureToken);
  }

  @override
  Future<void> userLogout() async {
    return await super.userLogout();
  }
}

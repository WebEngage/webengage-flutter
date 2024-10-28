import 'dart:html';
import 'dart:js_util' as js_util;

import 'package:flutter/src/services/message_codec.dart';
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';
import 'package:webengage_flutter_web/src/extension/we_extension.dart';
import 'package:webengage_flutter_web/src/model/we_web.dart';
import 'package:webengage_flutter_web/src/utils/we_constants.dart';

class WebengageFlutterWeb extends WEMethodChannel {
  var webengage, user;
  WEWeb? _web;

  static void registerWith([Object? registrar]) {
    WEPlatformInterface.instance = WebengageFlutterWeb();
  }

  @override
  void init() {
    webEngageInitialize();
  }

  void webEngageInitialize() {
    webengage = js_util.getProperty(window, WEB_WEBENGAGE);
    user = js_util.getProperty(webengage, WEB_METHOD_NAME_USER);
  }

  @override
  Future<void> platformCallHandler(MethodCall call) {
    WELogger.e("platformCallHandler $WEB_METHOD_NOT_SUPPORTED");
    return Future.value();
  }

  @override
  @override
  Future<void> setSecureToken(String userId, String secureToken) {
    performUserAction(WEB_METHOD_NAME_USER_LOGIN, [userId, secureToken]);
    return Future.value();
  }

  @override
  void setUpInAppCallbacks(
      MessageHandlerInAppClick onInAppClick,
      MessageHandler onInAppShown,
      MessageHandler onInAppDismiss,
      MessageHandler onInAppPrepared) {
    WELogger.i("setUpInAppCallbacks $WEB_METHOD_NOT_SUPPORTED");
  }

  @override
  void setUpPushCallbacks(MessageHandlerPushClick onPushClick,
      MessageHandlerPushClick onPushActionClick) {
    WELogger.i("setUpPushCallbacks $WEB_METHOD_NOT_SUPPORTED");
  }

  @override
  Future<void> setUserAttribute(String attributeName, userAttributeValue) {
    performUserAttributeAction([attributeName, userAttributeValue]);
    return Future.value();
  }

  @override
  Future<void> setUserAttributes(Map userAttributeValue) {
    performUserAttributeAction(js_util.jsify(userAttributeValue));
    return Future.value();
  }

  @override
  Future<void> setUserBirthDate(String birthDate) {
    performUserAttributeAction([WEB_ATTRIBUTE_NAME_BIRTH_DATE, birthDate]);
    return Future.value();
  }

  @override
  Future<void> setUserCompany(String company) {
    performUserAttributeAction([WEB_ATTRIBUTE_NAME_COMPANY, company]);
    return Future.value();
  }

  @override
  Future<void> setUserDevicePushOptIn(bool status) {
    // TODO : NOT WORKING
    performUserAttributeAction([WEB_ATTRIBUTE_NAME_PUSH_OPT_IN, status]);
    return Future.value();
  }

  @override
  Future<void> setUserEmail(String email) {
    performUserAttributeAction([WEB_ATTRIBUTE_NAME_EMAIL, email]);
    return Future.value();
  }

  @override
  Future<void> setUserFirstName(String firstName) {
    performUserAttributeAction([WEB_ATTRIBUTE_NAME_FIRST_NAME, firstName]);
    return Future.value();
  }

  @override
  Future<void> setUserGender(String gender) {
    performUserAttributeAction([WEB_ATTRIBUTE_NAME_GENDER, gender]);
    return Future.value();
  }

  @override
  Future<void> setUserHashedEmail(String email) {
    performUserAttributeAction([WEB_ATTRIBUTE_NAME_HASH_EMAIL, email]);
    return Future.value();
  }

  @override
  Future<void> setUserHashedPhone(String phone) {
    performUserAttributeAction([WEB_ATTRIBUTE_NAME_HASH_PHONE, phone]);
    return Future.value();
  }

  @override
  Future<void> setUserLastName(String lastName) {
    performUserAttributeAction([WEB_ATTRIBUTE_NAME_LAST_NAME, lastName]);
    return Future.value();
  }

  @override
  Future<void> setUserLocation(double lat, double lng) {
    // TODO : how to pass it
    return Future.value();
  }

  @override
  Future<void> setUserOptIn(String channel, bool optIn) {
    // TODO : Need to check
    performUserAttributeAction([channel, optIn]);
    return Future.value();
  }

  @override
  Future<void> setUserPhone(String phone) {
    performUserAttributeAction([WEB_ATTRIBUTE_NAME_PHONE, phone]);
    return Future.value();
  }

  @override
  Future<void> startGAIDTracking() {
    WELogger.e("startGAIDTracking $WEB_METHOD_NOT_SUPPORTED");
    return Future.value();
  }

  @override
  void tokenInvalidatedCallback(MessageHandler onTokenInvalidated) {
    // TODO: implement tokenInvalidatedCallback
  }

  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? attributes]) {
    performTrackEvent(eventName, attributes);
    return Future.value();
  }

  @override
  Future<void> trackScreen(String screenName,
      [Map<String, dynamic>? screenData]) {
    // TODO : not working
    performTrackScreen(screenName, screenData);
    return Future.value();
  }

  @override
  Future<void> userLogin(String userId, [String? secureToken]) {
    performUserAction(WEB_METHOD_NAME_USER_LOGIN, [userId, secureToken]);
    return Future.value();
  }

  @override
  Future<void> userLogout() {
    performUserAction(WEB_METHOD_NAME_USER_LOGOUT, []);
    return Future.value();
  }

  @override
  WEWeb? web() {
    _web ??= WEWebImplementation(webengage);
    return _web;
  }
}

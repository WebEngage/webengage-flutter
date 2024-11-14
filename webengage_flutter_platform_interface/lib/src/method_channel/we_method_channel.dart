import 'dart:async';

import 'package:flutter/services.dart' hide MessageHandler;

import '../../webengage_flutter_platform_interface.dart';

class WEMethodChannel extends WEPlatformInterface {
  MessageHandlerPushClick? onPushClick;
  MessageHandlerPushClick? onPushActionClick;
  MessageHandlerInAppClick? onInAppClick;
  MessageHandler? onInAppShown;
  MessageHandler? onInAppDismiss;
  MessageHandler? onInAppPrepared;
  MessageHandler? onTokenInvalidated;
  WEPushNotificationClick? onWEPushNotificationClick;

  MethodChannel methodChannel = const MethodChannel(channelName);

  final StreamController<Map<String, dynamic>?> anonymousIDStream =
      StreamController();

  final StreamController<PushPayload> pushActionClickStream =
      new StreamController<PushPayload>();

  final StreamController<PushPayload> pushClickStream =
      StreamController<PushPayload>();

  final StreamController<String?> trackDeeplinkURLStream =
      new StreamController<String?>();

  @override
  Sink get anonymousActionSink {
    return anonymousIDStream.sink;
  }

  @override
  Stream<Map<String, dynamic>?> get anonymousActionStream {
    return anonymousIDStream.stream;
  }

  @override
  Future<void> platformCallHandler(MethodCall call) {
    throw UnimplementedError();
  }

  @override
  Sink get pushActionSink {
    return pushActionClickStream.sink;
  }

  @override
  Stream<PushPayload> get pushActionStream {
    return pushActionClickStream.stream;
  }

  @override
  Sink get pushSink {
    return pushClickStream.sink;
  }

  @override
  Stream<PushPayload> get pushStream {
    return pushClickStream.stream;
  }

  @override
  Stream<String?> get trackDeeplinkStream {
    return trackDeeplinkURLStream.stream;
  }

  @override
  Sink get trackDeeplinkURLStreamSink {
    return trackDeeplinkURLStream.sink;
  }

  @override
  void setUpInAppCallbacks(
      MessageHandlerInAppClick onInAppClick,
      MessageHandler onInAppShown,
      MessageHandler onInAppDismiss,
      MessageHandler onInAppPrepared) {
    this.onInAppClick = onInAppClick;
    this.onInAppShown = onInAppShown;
    this.onInAppDismiss = onInAppDismiss;
    this.onInAppPrepared = onInAppPrepared;
  }

  @override
  void setUpPushCallbacks(MessageHandlerPushClick onPushClick,
      MessageHandlerPushClick onPushActionClick) {
    this.onPushClick = onPushClick;
    this.onPushActionClick = onPushActionClick;
  }

  @override
  Future<void> setUserAttribute(
      String attributeName, userAttributeValue) async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_USER_ATTRIBUTE,
        {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
  }

  @override
  Future<void> setUserAttributes(Map userAttributeValue) async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_USER_MAP_ATTRIBUTE,
        {ATTRIBUTE_NAME: "attributeName", ATTRIBUTES: userAttributeValue});
  }

  @override
  Future<void> setUserBirthDate(String birthDate) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_BIRTHDATE, birthDate);
  }

  @override
  Future<void> setUserCompany(String company) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_COMPANY, company);
  }

  @override
  Future<void> setUserDevicePushOptIn(bool status) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_DEVICE_PUSH_OPT_IN, status);
  }

  @override
  Future<void> setUserEmail(String email) async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_USER_EMAIL, email);
  }

  @override
  Future<void> setUserFirstName(String firstName) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_FIRST_NAME, firstName);
  }

  @override
  Future<void> setUserGender(String gender) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_GENDER, gender);
  }

  @override
  Future<void> setUserHashedEmail(String email) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_HASHED_EMAIL, email);
  }

  @override
  Future<void> setUserHashedPhone(String phone) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_HASHED_PHONE, phone);
  }

  @override
  Future<void> setUserLastName(String lastName) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_LAST_NAME, lastName);
  }

  @override
  Future<void> setUserLocation(double lat, double lng) async {
    return await methodChannel
        .invokeMethod(METHOD_NAME_SET_USER_LOCATION, {LAT: lat, LNG: lng});
  }

  @override
  Future<void> setUserOptIn(String channel, bool optIn) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_OPT_IN, {CHANNEL: channel, OPTIN: optIn});
  }

  @override
  Future<void> setUserPhone(String phone) async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_USER_PHONE, phone);
  }

  @override
  Future<void> startGAIDTracking() async {
    return await methodChannel.invokeMethod(METHOD_NAME_START_GAID_TRACKING);
  }

  @override
  void tokenInvalidatedCallback(MessageHandler onTokenInvalidated) {
    this.onTokenInvalidated = onTokenInvalidated;
  }

  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? attributes]) async {
    return await methodChannel.invokeMethod(METHOD_NAME_TRACK_EVENT,
        {EVENT_NAME: eventName, ATTRIBUTES: attributes});
  }

  @override
  Future<void> trackScreen(String screenName,
      [Map<String, dynamic>? screenData]) async {
    return await methodChannel.invokeMethod(METHOD_NAME_TRACK_SCREEN,
        {SCREEN_NAME: screenName, SCREEN_DATA: screenData});
  }

  @override
  Future<void> userLogin(String userId, [String? secureToken]) async {
    if (secureToken != null) {
      return await methodChannel.invokeMethod(
          METHOD_NAME_SET_USER_LOGIN_WITH_SECURE_TOKEN,
          {USERID: userId, SECURE_TOKEN: secureToken});
    } else {
      return await methodChannel.invokeMethod(
          METHOD_NAME_SET_USER_LOGIN, userId);
    }
  }

  @override
  Future<void> setSecureToken(String userId, String secureToken) async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_SECURE_TOKEN,
        {USERID: userId, SECURE_TOKEN: secureToken});
  }

  @override
  Future<void> userLogout() async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_USER_LOGOUT);
  }

  @override
  void init() {
    methodChannel.setMethodCallHandler(platformCallHandler);
    methodChannel.invokeMethod(methodInitialise);
  }

  @override
  WEWeb? web() {
    WELogger.v("web : : Not supported in Android/iOS Platform");
    return null;
  }

  @override
  void setWEPushNotificationClick(
      WEPushNotificationClick wePushNotificationClick) {
    onWEPushNotificationClick = wePushNotificationClick;
  }

  @override
  void onPushMessageReceive(Map<String, dynamic>? data) {
    methodChannel
        .invokeMethod(METHOD_NAME_ON_PUSH_MESSAGE_RECEIVED, {"data": data});
  }

  @override
  void setPushToken(String pushToken) {
    methodChannel.invokeMethod(METHOD_NAME_ON_PUSH_TOKEN, pushToken);
  }
}

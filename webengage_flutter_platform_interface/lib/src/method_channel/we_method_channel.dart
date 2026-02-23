import 'dart:async';

import 'package:flutter/services.dart' hide MessageHandler;

import '../../webengage_flutter_platform_interface.dart';

/// Method channel implementation of [WEPlatformInterface].
///
/// Handles communication between Flutter and native platforms using
/// [MethodChannel] and exposes streams/callbacks for push, in-app,
/// deep link, and user related events.
class WEMethodChannel extends WEPlatformInterface {
  /// Callback triggered when a push notification is clicked.
  MessageHandlerPushClick? onPushClick;

  /// Callback triggered when a push action button is clicked.
  MessageHandlerPushClick? onPushActionClick;

  /// Callback triggered when an in-app message is clicked.
  MessageHandlerInAppClick? onInAppClick;

  /// Callback triggered when an in-app message is shown.
  MessageHandler? onInAppShown;

  /// Callback triggered when an in-app message is dismissed.
  MessageHandler? onInAppDismiss;

  /// Callback triggered when an in-app message is prepared.
  MessageHandler? onInAppPrepared;

  /// Callback triggered when the push token becomes invalid.
  MessageHandler? onTokenInvalidated;

  /// Callback triggered for push notification clicks.
  WEPushNotificationClick? onWEPushNotificationClick;

  /// Method channel used to communicate with native SDKs.
  MethodChannel methodChannel = const MethodChannel(channelName);

  /// Stream controller for anonymous user actions.
  final StreamController<Map<String, dynamic>?> anonymousIDStream =
      StreamController();

  /// Stream controller for push action click events.
  final StreamController<PushPayload> pushActionClickStream =
      StreamController<PushPayload>();

  /// Stream controller for push notification click events.
  final StreamController<PushPayload> pushClickStream =
      StreamController<PushPayload>();

  /// Stream controller for deep link tracking URLs.
  final StreamController<String?> trackDeeplinkURLStream =
      StreamController<String?>();

  /// Sink for anonymous user actions.
  @override
  Sink get anonymousActionSink => anonymousIDStream.sink;

  /// Stream for anonymous user actions.
  @override
  Stream<Map<String, dynamic>?> get anonymousActionStream =>
      anonymousIDStream.stream;

  /// Handles incoming method calls from native platforms.
  @override
  Future<void> platformCallHandler(MethodCall call) {
    throw UnimplementedError();
  }

  /// Sink for push action click events.
  @override
  Sink get pushActionSink => pushActionClickStream.sink;

  /// Stream for push action click events.
  @override
  Stream<PushPayload> get pushActionStream => pushActionClickStream.stream;

  /// Sink for push notification click events.
  @override
  Sink get pushSink => pushClickStream.sink;

  /// Stream for push notification click events.
  @override
  Stream<PushPayload> get pushStream => pushClickStream.stream;

  /// Stream for tracked deep link URLs.
  @override
  Stream<String?> get trackDeeplinkStream => trackDeeplinkURLStream.stream;

  /// Sink for tracked deep link URLs.
  @override
  Sink get trackDeeplinkURLStreamSink => trackDeeplinkURLStream.sink;

  /// Sets callbacks for in-app message events.
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

  /// Sets callbacks for push notification events.
  @override
  void setUpPushCallbacks(MessageHandlerPushClick onPushClick,
      MessageHandlerPushClick onPushActionClick) {
    this.onPushClick = onPushClick;
    this.onPushActionClick = onPushActionClick;
  }

  /// Sets a single user attribute.
  @override
  Future<void> setUserAttribute(
      String attributeName, userAttributeValue) async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_USER_ATTRIBUTE,
        {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
  }

  /// Sets multiple user attributes.
  @override
  Future<void> setUserAttributes(Map userAttributeValue) async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_USER_MAP_ATTRIBUTE,
        {ATTRIBUTE_NAME: "attributeName", ATTRIBUTES: userAttributeValue});
  }

  /// Sets the user's birth date.
  @override
  Future<void> setUserBirthDate(String birthDate) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_BIRTHDATE, birthDate);
  }

  /// Sets the user's company.
  @override
  Future<void> setUserCompany(String company) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_COMPANY, company);
  }

  /// Enables or disables device push opt-in.
  @override
  Future<void> setUserDevicePushOptIn(bool status) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_DEVICE_PUSH_OPT_IN, status);
  }

  /// Sets the user's email.
  @override
  Future<void> setUserEmail(String email) async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_USER_EMAIL, email);
  }

  /// Sets the user's first name.
  @override
  Future<void> setUserFirstName(String firstName) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_FIRST_NAME, firstName);
  }

  /// Sets the user's gender.
  @override
  Future<void> setUserGender(String gender) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_GENDER, gender);
  }

  /// Sets the user's hashed email.
  @override
  Future<void> setUserHashedEmail(String email) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_HASHED_EMAIL, email);
  }

  /// Sets the user's hashed phone number.
  @override
  Future<void> setUserHashedPhone(String phone) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_HASHED_PHONE, phone);
  }

  /// Sets the user's last name.
  @override
  Future<void> setUserLastName(String lastName) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_LAST_NAME, lastName);
  }

  /// Sets the user's geographic location.
  @override
  Future<void> setUserLocation(double lat, double lng) async {
    return await methodChannel
        .invokeMethod(METHOD_NAME_SET_USER_LOCATION, {LAT: lat, LNG: lng});
  }

  /// Sets user opt-in status for a specific channel.
  @override
  Future<void> setUserOptIn(String channel, bool optIn) async {
    return await methodChannel.invokeMethod(
        METHOD_NAME_SET_USER_OPT_IN, {CHANNEL: channel, OPTIN: optIn});
  }

  /// Sets the user's phone number.
  @override
  Future<void> setUserPhone(String phone) async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_USER_PHONE, phone);
  }

  /// Starts GAID tracking.
  @override
  Future<void> startGAIDTracking() async {
    return await methodChannel.invokeMethod(METHOD_NAME_START_GAID_TRACKING);
  }

  /// Registers callback for token invalidation.
  @override
  void tokenInvalidatedCallback(MessageHandler onTokenInvalidated) {
    this.onTokenInvalidated = onTokenInvalidated;
  }

  /// Tracks a custom event with optional attributes.
  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? attributes]) async {
    return await methodChannel.invokeMethod(METHOD_NAME_TRACK_EVENT,
        {EVENT_NAME: eventName, ATTRIBUTES: attributes});
  }

  /// Tracks a screen view with optional screen data.
  @override
  Future<void> trackScreen(String screenName,
      [Map<String, dynamic>? screenData]) async {
    return await methodChannel.invokeMethod(METHOD_NAME_TRACK_SCREEN,
        {SCREEN_NAME: screenName, SCREEN_DATA: screenData});
  }

  /// Logs in a user with optional secure token.
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

  /// Sets secure token for a user.
  @override
  Future<void> setSecureToken(String userId, String secureToken) async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_SECURE_TOKEN,
        {USERID: userId, SECURE_TOKEN: secureToken});
  }

  /// Logs out the current user.
  @override
  Future<void> userLogout() async {
    return await methodChannel.invokeMethod(METHOD_NAME_SET_USER_LOGOUT);
  }

  /// Initializes the method channel and native SDK.
  @override
  void init() {
    methodChannel.setMethodCallHandler(platformCallHandler);
    methodChannel.invokeMethod(methodInitialise);
  }

  /// Returns web implementation (not supported on mobile).
  @override
  WEWeb? web() {
    WELogger.v("web : : Not supported in Android/iOS Platform");
    return null;
  }

  /// Sets push notification click callback.
  @override
  void setWEPushNotificationClick(
      WEPushNotificationClick wePushNotificationClick) {
    onWEPushNotificationClick = wePushNotificationClick;
  }

  /// Notifies native SDK when a push message is received.
  @override
  void onPushMessageReceive(Map<String, dynamic>? data) {
    methodChannel
        .invokeMethod(METHOD_NAME_ON_PUSH_MESSAGE_RECEIVED, {"data": data});
  }

  /// Sends push token to native SDK.
  @override
  void setPushToken(String pushToken) {
    methodChannel.invokeMethod(METHOD_NAME_ON_PUSH_TOKEN, pushToken);
  }
}

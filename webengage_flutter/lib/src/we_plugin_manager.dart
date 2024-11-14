import 'dart:async';

import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

/// A Flutter plugin for integrating WebEngage SDK into your Flutter applications.
class WePluginManager {
  WEPlatformInterface get _platform => WEPlatformInterface.instance;

  static final WePluginManager _webengagePlugin =
      new WePluginManager._internal();

  factory WePluginManager() => _webengagePlugin;

  WePluginManager._internal() {}

  void init() {
    _platform.init();
  }

  Stream<PushPayload> get pushStream {
    return _platform.pushStream;
  }

  Sink get pushSink {
    return _platform.pushSink;
  }

  Stream<PushPayload> get pushActionStream {
    return _platform.pushActionStream;
  }

  Sink get pushActionSink {
    return _platform.pushActionSink;
  }

  Stream<Map<String, dynamic>?> get anonymousActionStream {
    return _platform.anonymousActionStream;
  }

  Sink get anonymousActionSink {
    return _platform.anonymousActionSink;
  }

  Stream<String?> get trackDeeplinkStream {
    return _platform.trackDeeplinkStream;
  }

  Sink get trackDeeplinkURLStreamSink {
    return _platform.trackDeeplinkURLStreamSink;
  }

  /// Deprecated: Use '_pushClickStream' and 'pushActionStream' instead. This method will be removed in future builds.
  ///
  /// Sets up callbacks for push notification click and action click events.
  ///
  /// [onPushClick]: Callback function for push notification click events.
  /// [onPushActionClick]: Callback function for push notification action click events.
  @Deprecated(
      "Use '_pushClickStream' & 'pushActionStream' instead. This method will be removed in future build.")
  void setUpPushCallbacks(MessageHandlerPushClick onPushClick,
      MessageHandlerPushClick onPushActionClick) {
    _platform.setUpPushCallbacks(onPushClick, onPushActionClick);
  }

  /// Sets the callback for handling push notification click events in the app.
  ///
  /// This method allows you to define a callback function, [wePushNotificationClick],
  /// that will be triggered whenever a push notification click is detected.
  /// The callback provides access to the notification payload data, allowing
  /// for custom handling of user interactions with push notifications.
  void setWEPushNotificationClick(
      WEPushNotificationClick wePushNotificationClick) {
    _platform.setWEPushNotificationClick(wePushNotificationClick);
  }

  /// Sets up callbacks for in-app notification events.
  ///
  /// [onInAppClick]: Callback function for in-app notification click events.
  /// [onInAppShown]: Callback function for in-app notification shown events.
  /// [onInAppDismiss]: Callback function for in-app notification dismiss events.
  /// [onInAppPrepared]: Callback function for in-app notification prepared events.
  void setUpInAppCallbacks(
    MessageHandlerInAppClick onInAppClick,
    MessageHandler onInAppShown,
    MessageHandler onInAppDismiss,
    MessageHandler onInAppPrepared,
  ) {
    _platform.setUpInAppCallbacks(
        onInAppClick, onInAppShown, onInAppDismiss, onInAppPrepared);
  }

  /// Sets up a callback for token invalidated events.
  ///
  /// [onTokenInvalidated]: Callback function for token invalidated from server.
  void tokenInvalidatedCallback(MessageHandler onTokenInvalidated) {
    _platform.tokenInvalidatedCallback(onTokenInvalidated);
  }

  /// Initiates a user login action with an optional secure token.
  ///
  /// [userId]: The unique identifier for the user.
  /// [secureToken]: The secure token for authentication, if applicable.
  Future<void> userLogin(String userId, [String? secureToken]) async {
    return await _platform.userLogin(userId, secureToken);
  }

  /// Sets a secure token for the specified user.
  ///
  /// [userId]: The unique identifier for the user.
  /// [secureToken]: The secure token for authentication.
  Future<void> setSecureToken(String userId, String secureToken) async {
    return await _platform.setSecureToken(userId, secureToken);
  }

  /// Initiates user logout.

  Future<void> userLogout() async {
    print("Manager");
    return await _platform.userLogout();
  }

  /// Sets the user's first name to [firstName].

  Future<void> setUserFirstName(String firstName) async {
    return await _platform.setUserFirstName(firstName);
  }

  /// Sets the user's last name to [lastName].

  Future<void> setUserLastName(String lastName) async {
    return await _platform.setUserLastName(lastName);
  }

  Future<void> setUserEmail(String email) async {
    return await _platform.setUserEmail(email);
  }

  Future<void> setUserHashedEmail(String email) async {
    return await _platform.setUserHashedEmail(email);
  }

  Future<void> setUserPhone(String phone) async {
    return await _platform.setUserPhone(phone);
  }

  Future<void> setUserHashedPhone(String phone) async {
    return await _platform.setUserHashedPhone(phone);
  }

  Future<void> setUserCompany(String company) async {
    return await _platform.setUserCompany(company);
  }

  /// Sets the user's birth date to the specified [birthDate].
  /// For more information, see the [Flutter Tracking Events documentation](https://docs.webengage.com/docs/flutter-tracking-events#tracking-custom-events--attributes).

  Future<void> setUserBirthDate(String birthDate) async {
    return await _platform.setUserBirthDate(birthDate);
  }

  /// Sets the user's gender to the specified [gender].

  Future<void> setUserGender(String gender) async {
    return await _platform.setUserGender(gender);
  }

  /// Sets the user's opt-in status for the specified [channel].

  Future<void> setUserOptIn(String channel, bool optIn) async {
    return await _platform.setUserOptIn(channel, optIn);
  }

  /// Sets the user's device push notification opt-in status to [status]

  Future<void> setUserDevicePushOptIn(bool status) async {
    return await _platform.setUserDevicePushOptIn(status);
  }

  /// Sets the user's location with the specified latitude [lat] and longitude [lng].

  Future<void> setUserLocation(double lat, double lng) async {
    return await _platform.setUserLocation(lat, lng);
  }

  /// Tracks an event with the specified [eventName] and optional [attributes].

  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? attributes]) async {
    return await _platform.trackEvent(eventName, attributes);
  }

  /// Sets user attributes with multiple values in the specified [userAttributeValue].

  Future<void> setUserAttributes(Map userAttributeValue) async {
    return await _platform.setUserAttributes(userAttributeValue);
  }

  /// Sets user attributes with single values in the specified [attributeName] and [userAttributeValue].

  Future<void> setUserAttribute(
      String attributeName, dynamic userAttributeValue) async {
    return await _platform.setUserAttribute(attributeName, userAttributeValue);
  }

  /// Tracks a screen with the specified [eventName] and optional [screenData].

  Future<void> trackScreen(String screenName,
      [Map<String, dynamic>? screenData]) async {
    return await _platform.trackScreen(screenName, screenData);
  }

  /// Starts tracking Google Advertising ID (GAID) on Android devices using platform channels.
  /// Returns a Future<void> indicating completion, or does nothing if the platform is not Android.

  Future<void> startGAIDTracking() async {
    return await _platform.startGAIDTracking();
  }

  void onPushMessageReceive(Map<String, dynamic>? data) {
    _platform.onPushMessageReceive(data);
  }

  void setPushToken(String pushToken) {
    _platform.setPushToken(pushToken);
  }

  WEWeb? web() {
    return _platform.web();
  }
}

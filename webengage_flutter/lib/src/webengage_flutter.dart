import 'dart:async';

import '../webengage_flutter.dart';

/// A Flutter plugin for integrating WebEngage SDK into your Flutter applications.
class WebEngagePlugin {
  static final WePluginManager _manager = WePluginManager();

  static final WebEngagePlugin _webengagePlugin =
      new WebEngagePlugin._internal();

  factory WebEngagePlugin() => _webengagePlugin;

  WebEngagePlugin._internal() {
    _manager.init();
  }

  Stream<PushPayload> get pushStream {
    return _manager.pushStream;
  }

  Sink get pushSink {
    return _manager.pushSink;
  }

  Stream<PushPayload> get pushActionStream {
    return _manager.pushActionStream;
  }

  Sink get pushActionSink {
    return _manager.pushActionSink;
  }

  Stream<Map<String, dynamic>?> get anonymousActionStream {
    return _manager.anonymousActionStream;
  }

  Sink get anonymousActionSink {
    return _manager.anonymousActionSink;
  }

  Stream<String?> get trackDeeplinkStream {
    return _manager.trackDeeplinkStream;
  }

  Sink get trackDeeplinkURLStreamSink {
    return _manager.trackDeeplinkURLStreamSink;
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
    _manager.setUpPushCallbacks(onPushClick, onPushActionClick);
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
    _manager.setUpInAppCallbacks(
        onInAppClick, onInAppShown, onInAppDismiss, onInAppPrepared);
  }

  /// Sets up a callback for token invalidated events.
  ///
  /// [onTokenInvalidated]: Callback function for token invalidated from server.
  void tokenInvalidatedCallback(MessageHandler onTokenInvalidated) {
    _manager.tokenInvalidatedCallback(onTokenInvalidated);
  }

  /// Initiates a user login action with an optional secure token.
  ///
  /// [userId]: The unique identifier for the user.
  /// [secureToken]: The secure token for authentication, if applicable.
  static Future<void> userLogin(String userId, [String? secureToken]) async {
    return await _manager.userLogin(userId, secureToken);
  }

  /// Sets a secure token for the specified user.
  ///
  /// [userId]: The unique identifier for the user.
  /// [secureToken]: The secure token for authentication.
  static Future<void> setSecureToken(String userId, String secureToken) async {
    return await _manager.setSecureToken(userId, secureToken);
  }

  /// Initiates user logout.
  static Future<void> userLogout() async {
    return await _manager.userLogout();
  }

  /// Sets the user's first name to [firstName].
  static Future<void> setUserFirstName(String firstName) async {
    return await _manager.setUserFirstName(firstName);
  }

  /// Sets the user's last name to [lastName].
  static Future<void> setUserLastName(String lastName) async {
    return await _manager.setUserLastName(lastName);
  }

  static Future<void> setUserEmail(String email) async {
    return await _manager.setUserEmail(email);
  }

  static Future<void> setUserHashedEmail(String email) async {
    return await _manager.setUserHashedEmail(email);
  }

  static Future<void> setUserPhone(String phone) async {
    return await _manager.setUserPhone(phone);
  }

  static Future<void> setUserHashedPhone(String phone) async {
    return await _manager.setUserHashedPhone(phone);
  }

  static Future<void> setUserCompany(String company) async {
    return await _manager.setUserCompany(company);
  }

  /// Sets the user's birth date to the specified [birthDate].
  /// For more information, see the [Flutter Tracking Events documentation](https://docs.webengage.com/docs/flutter-tracking-events#tracking-custom-events--attributes).
  static Future<void> setUserBirthDate(String birthDate) async {
    return await _manager.setUserBirthDate(birthDate);
  }

  /// Sets the user's gender to the specified [gender].
  static Future<void> setUserGender(String gender) async {
    return await _manager.setUserGender(gender);
  }

  /// Sets the user's opt-in status for the specified [channel].
  static Future<void> setUserOptIn(String channel, bool optIn) async {
    return await _manager.setUserOptIn(channel, optIn);
  }

  /// Sets the user's device push notification opt-in status to [status]
  static Future<void> setUserDevicePushOptIn(bool status) async {
    return await _manager.setUserDevicePushOptIn(status);
  }

  /// Sets the user's location with the specified latitude [lat] and longitude [lng].
  static Future<void> setUserLocation(double lat, double lng) async {
    return await _manager.setUserLocation(lat, lng);
  }

  /// Tracks an event with the specified [eventName] and optional [attributes].
  static Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? attributes]) async {
    return await _manager.trackEvent(eventName, attributes);
  }

  /// Sets user attributes with multiple values in the specified [userAttributeValue].
  static Future<void> setUserAttributes(Map userAttributeValue) async {
    return await _manager.setUserAttributes(userAttributeValue);
  }

  /// Sets user attributes with single values in the specified [attributeName] and [userAttributeValue].
  static Future<void> setUserAttribute(
      String attributeName, dynamic userAttributeValue) async {
    return await _manager.setUserAttribute(attributeName, userAttributeValue);
  }

  /// Tracks a screen with the specified [eventName] and optional [screenData].
  static Future<void> trackScreen(String eventName,
      [Map<String, dynamic>? screenData]) async {
    return await _manager.trackScreen(eventName, screenData);
  }

  /// Starts tracking Google Advertising ID (GAID) on Android devices using platform channels.
  /// Returns a Future<void> indicating completion, or does nothing if the platform is not Android.
  static Future<void> startGAIDTracking() async {
    return await _manager.startGAIDTracking();
  }

  static WEWeb? web() {
    return _manager.web();
  }
}

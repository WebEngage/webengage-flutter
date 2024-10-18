// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

import '../push_payload.dart';
import 'constants.dart';

typedef MessageHandler<T> = void Function(Map<String, T>? message);
typedef MessageHandlerInAppClick<T> = void Function(
    Map<String, T>? message, String? s);
typedef MessageHandlerPushClick<T> = void Function(
    Map<String, T>? message, String? s);

/// A Flutter plugin for integrating WebEngage SDK into your Flutter applications.
class WebEngagePlugin {
  /// The method channel used for communication between Flutter and native code.
  static const MethodChannel _channel =
      const MethodChannel('webengage_flutter');

  /// Singleton instance of [WebEngagePlugin].
  static final WebEngagePlugin _webengagePlugin =
      new WebEngagePlugin._internal();

  factory WebEngagePlugin() => _webengagePlugin;

  WebEngagePlugin._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
    _channel.invokeMethod(methodInitialise);
  }

  MessageHandlerPushClick? _onPushClick;
  MessageHandlerPushClick? _onPushActionClick;
  MessageHandlerInAppClick? _onInAppClick;
  MessageHandler? _onInAppShown;
  MessageHandler? _onInAppDismiss;
  MessageHandler? _onInAppPrepared;
  MessageHandler? _onTokenInvalidated;

  //Push Stream
  final StreamController<PushPayload> _pushClickStream =
      StreamController<PushPayload>();

  Stream<PushPayload> get pushStream {
    return _pushClickStream.stream;
  }

  Sink get pushSink {
    return _pushClickStream.sink;
  }

  //Push Action click
  // ignore: close_sinks
  final StreamController<PushPayload> _pushActionClickStream =
      new StreamController<PushPayload>();

  Stream<PushPayload> get pushActionStream {
    return _pushActionClickStream.stream;
  }

  Sink get pushActionSink {
    return _pushActionClickStream.sink;
  }

  //StateChangeCallback AnonymousId
  final StreamController<Map<String, dynamic>?> _anonymousIDStream =
      StreamController();

  Stream<Map<String, dynamic>?> get anonymousActionStream {
    return _anonymousIDStream.stream;
  }

  Sink get anonymousActionSink {
    return _anonymousIDStream.sink;
  }

  //
  final StreamController<String?> _trackDeeplinkURLStream =
      new StreamController<String?>();

  Stream<String?> get trackDeeplinkStream {
    return _trackDeeplinkURLStream.stream;
  }

  Sink get trackDeeplinkURLStreamSink {
    return _trackDeeplinkURLStream.sink;
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
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
    _onPushClick = onPushClick;
    _onPushActionClick = onPushActionClick;
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
    _onInAppClick = onInAppClick;
    _onInAppShown = onInAppShown;
    _onInAppDismiss = onInAppDismiss;
    _onInAppPrepared = onInAppPrepared;
  }

  /// Sets up a callback for token invalidated events.
  ///
  /// [onTokenInvalidated]: Callback function for token invalidated from server.
  void tokenInvalidatedCallback(MessageHandler onTokenInvalidated) {
    _onTokenInvalidated = onTokenInvalidated;
  }

  /// Initiates a user login action with an optional secure token.
  ///
  /// [userId]: The unique identifier for the user.
  /// [secureToken]: The secure token for authentication, if applicable.
  static Future<void> userLogin(String userId, [String? secureToken]) async {
    if (secureToken != null) {
      return await _channel.invokeMethod(
          METHOD_NAME_SET_USER_LOGIN_WITH_SECURE_TOKEN,
          {USERID: userId, SECURE_TOKEN: secureToken});
    } else {
      return await _channel.invokeMethod(METHOD_NAME_SET_USER_LOGIN, userId);
    }
  }

  /// Sets a secure token for the specified user.
  ///
  /// [userId]: The unique identifier for the user.
  /// [secureToken]: The secure token for authentication.
  static Future<void> setSecureToken(String userId, String secureToken) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_SECURE_TOKEN,
        {USERID: userId, SECURE_TOKEN: secureToken});
  }

  /// Initiates user logout.
  static Future<void> userLogout() async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_LOGOUT);
  }

  /// Sets the user's first name to [firstName].
  static Future<void> setUserFirstName(String firstName) async {
    return await _channel.invokeMethod(
        METHOD_NAME_SET_USER_FIRST_NAME, firstName);
  }

  /// Sets the user's last name to [lastName].
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

  /// Sets the user's birth date to the specified [birthDate].
  /// For more information, see the [Flutter Tracking Events documentation](https://docs.webengage.com/docs/flutter-tracking-events#tracking-custom-events--attributes).
  static Future<void> setUserBirthDate(String birthDate) async {
    return await _channel.invokeMethod(
        METHOD_NAME_SET_USER_BIRTHDATE, birthDate);
  }

  /// Sets the user's gender to the specified [gender].
  static Future<void> setUserGender(String gender) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_GENDER, gender);
  }

  /// Sets the user's opt-in status for the specified [channel].
  static Future<void> setUserOptIn(String channel, bool optIn) async {
    return await _channel.invokeMethod(
        METHOD_NAME_SET_USER_OPT_IN, {CHANNEL: channel, OPTIN: optIn});
  }

  /// Sets the user's device push notification opt-in status to [status]
  static Future<void> setUserDevicePushOptIn(bool status) async {
    return await _channel.invokeMethod(
        METHOD_NAME_SET_USER_DEVICE_PUSH_OPT_IN, status);
  }

  /// Sets the user's location with the specified latitude [lat] and longitude [lng].
  static Future<void> setUserLocation(double lat, double lng) async {
    return await _channel
        .invokeMethod(METHOD_NAME_SET_USER_LOCATION, {LAT: lat, LNG: lng});
  }

  /// Tracks an event with the specified [eventName] and optional [attributes].
  static Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? attributes]) async {
    return await _channel.invokeMethod(METHOD_NAME_TRACK_EVENT,
        {EVENT_NAME: eventName, ATTRIBUTES: attributes});
  }

  /// Sets user attributes with multiple values in the specified [userAttributeValue].
  static Future<void> setUserAttributes(Map userAttributeValue) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_MAP_ATTRIBUTE,
        {ATTRIBUTE_NAME: "attributeName", ATTRIBUTES: userAttributeValue});
  }

  /// Sets user attributes with single values in the specified [attributeName] and [userAttributeValue].
  static Future<void> setUserAttribute(
      String attributeName, dynamic userAttributeValue) async {
    return await _channel.invokeMethod(METHOD_NAME_SET_USER_ATTRIBUTE,
        {ATTRIBUTE_NAME: attributeName, ATTRIBUTES: userAttributeValue});
  }

  /// Tracks a screen with the specified [eventName] and optional [screenData].
  static Future<void> trackScreen(String eventName,
      [Map<String, dynamic>? screenData]) async {
    return await _channel.invokeMethod(METHOD_NAME_TRACK_SCREEN,
        {SCREEN_NAME: eventName, SCREEN_DATA: screenData});
  }

  /// Platform call handler for handling method calls from the native side.
  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call ${call.method} ${call.arguments}");
    if (call.method == callbackOnPushClick ||
        call.method == callbackOnPushActionClick) {
      Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        String? deepLink = message![PAYLOAD][URI];
        Map<String, dynamic>? newPayload =
            message[PAYLOAD].cast<String, dynamic>();
        PushPayload pushPayload = PushPayload();
        pushPayload.deepLink = deepLink;
        pushPayload.payload = newPayload;
        if (call.method == callbackOnPushClick) {
          _pushClickStream.sink.add(pushPayload);
          //TODO Deprecated will be removed in future builds
          if (null != _onPushClick) {
            _onPushClick!(newPayload, deepLink);
          }
        } else if (call.method == callbackOnPushActionClick) {
          _pushActionClickStream.sink.add(pushPayload);
          //TODO Deprecated will be removed in future builds
          if (null != _onPushActionClick) {
            _onPushActionClick!(newPayload, deepLink);
          }
        }
      } else {
        String? deepLink = message![DEEPLINK];
        Map<String, dynamic>? newPayload =
            call.arguments.cast<String, dynamic>();
        PushPayload pushPayload = PushPayload();
        pushPayload.deepLink = deepLink;
        pushPayload.payload = newPayload;
        if (call.method == callbackOnPushClick) {
          _pushClickStream.sink.add(pushPayload);
        } else if (call.method == callbackOnPushActionClick) {
          _pushActionClickStream.sink.add(pushPayload);
        }
      }
    }

    if (call.method == callbackOnInAppClicked && _onInAppClick != null) {
      Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        String? selectedActionId = message![PAYLOAD][SELECTED_ACTION_ID];
        Map<String, dynamic>? newPayload =
            message[PAYLOAD].cast<String, dynamic>();
        _onInAppClick!(newPayload, selectedActionId);
      } else {
        String? selectedActionId = message![SELECTED_ACTION_ID];
        _onInAppClick!(
            call.arguments.cast<String, dynamic>(), selectedActionId);
      }
    }

    if (call.method == callbackOnInAppShown && _onInAppShown != null) {
      Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        Map<String, dynamic>? newPayload =
            message![PAYLOAD].cast<String, dynamic>();
        _onInAppShown!(newPayload);
      } else {
        _onInAppShown!(call.arguments.cast<String, dynamic>());
      }
    }

    if (call.method == callbackOnInAppDismissed && _onInAppDismiss != null) {
      Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        Map<String, dynamic>? newPayload =
            message![PAYLOAD].cast<String, dynamic>();
        _onInAppDismiss!(newPayload);
      } else {
        _onInAppDismiss!(call.arguments.cast<String, dynamic>());
      }
    }

    if (call.method == callbackOnInAppPrepared && _onInAppPrepared != null) {
      Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        Map<String, dynamic>? newPayload =
            message?[PAYLOAD].cast<String, dynamic>();
        _onInAppPrepared!(newPayload);
      } else {
        _onInAppPrepared!(call.arguments.cast<String, dynamic>());
      }
    }

    if (call.method == callbackOnTokenInvalidated &&
        _onTokenInvalidated != null) {
      Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
      if (Platform.isAndroid) {
        Map<String, dynamic>? newPayload =
            message?[PAYLOAD].cast<String, dynamic>();
        _onTokenInvalidated!(newPayload);
      } else {
        _onTokenInvalidated!(call.arguments.cast<String, dynamic>());
      }
    }

    switch (call.method) {
      case callbackOnAnonymousIdChanged:
        _onAnonymousUdChanged(call);
        break;
    }

    if (call.method == METHOD_TRACK_DEEPLINK_URL) {
      String? locationLink = call.arguments;
      _trackDeeplinkURLStream.sink.add(locationLink);
    }
  }

  void _onAnonymousUdChanged(MethodCall call) {
    _anonymousIDStream.sink.add(_generateMap(call));
  }

  Map<String, dynamic>? _generateMap(MethodCall call) {
    if (Platform.isAndroid) {
      Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
      return message?[PAYLOAD].cast<String, dynamic>();
    } else {
      return call.arguments.cast<String, dynamic>();
    }
  }

  /// Starts tracking Google Advertising ID (GAID) on Android devices using platform channels.
  /// Returns a Future<void> indicating completion, or does nothing if the platform is not Android.
  static Future<void> startGAIDTracking() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod(METHOD_NAME_START_GAID_TRACKING);
    } else {
      return;
    }
  }
}

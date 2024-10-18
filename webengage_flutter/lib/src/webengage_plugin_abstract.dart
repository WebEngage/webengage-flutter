import 'dart:async';

import 'package:flutter/services.dart';
import 'package:webengage_flutter/push_payload.dart';

typedef MessageHandler<T> = void Function(Map<String, T>? message);
typedef MessageHandlerInAppClick<T> = void Function(
    Map<String, T>? message, String? s);
typedef MessageHandlerPushClick<T> = void Function(
    Map<String, T>? message, String? s);

abstract class WEPluginAbstract {
  static const MethodChannel channel = MethodChannel('webengage_flutter');

  Stream<PushPayload> get pushStream;

  Sink get pushSink;

  Stream<PushPayload> get pushActionStream;

  Sink get pushActionSink;

  Stream<Map<String, dynamic>?> get anonymousActionStream;

  Sink get anonymousActionSink;

  Stream<String?> get trackDeeplinkStream;

  Sink get trackDeeplinkURLStreamSink;

  void setUpPushCallbacks(MessageHandlerPushClick onPushClick,
      MessageHandlerPushClick onPushActionClick);

  void setUpInAppCallbacks(
      MessageHandlerInAppClick onInAppClick,
      MessageHandler onInAppShown,
      MessageHandler onInAppDismiss,
      MessageHandler onInAppPrepared);

  void tokenInvalidatedCallback(MessageHandler onTokenInvalidated);

  Future<void> userLogin(String userId, [String? secureToken]);

  Future<void> setSecureToken(String userId, String secureToken);

  Future<void> userLogout();

  Future<void> setUserFirstName(String firstName);

  Future<void> setUserLastName(String lastName);

  Future<void> setUserEmail(String email);

  Future<void> setUserHashedEmail(String email);

  Future<void> setUserPhone(String phone);

  Future<void> setUserHashedPhone(String phone);

  Future<void> setUserCompany(String company);

  Future<void> setUserBirthDate(String birthDate);

  Future<void> setUserGender(String gender);

  Future<void> setUserOptIn(String channel, bool optIn);

  Future<void> setUserDevicePushOptIn(bool status);

  Future<void> setUserLocation(double lat, double lng);

  Future<void> trackEvent(String eventName, [Map<String, dynamic>? attributes]);

  Future<void> setUserAttributes(Map userAttributeValue);

  Future<void> setUserAttribute(
      String attributeName, dynamic userAttributeValue);

  Future<void> trackScreen(String eventName,
      [Map<String, dynamic>? screenData]);

  Future<void> startGAIDTracking();

  Future<void> platformCallHandler(MethodCall call);
}

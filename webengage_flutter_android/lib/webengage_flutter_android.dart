import 'package:flutter/services.dart' hide MessageHandler;
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

class WebEngageFlutterAndroid extends WebEngageFlutterPlatform {
  final MethodChannel _methodChannel = const MethodChannel(channelName);

  @override
  // TODO: implement anonymousActionSink
  Sink get anonymousActionSink => throw UnimplementedError();

  @override
  // TODO: implement anonymousActionStream
  Stream<Map<String, dynamic>?> get anonymousActionStream =>
      throw UnimplementedError();

  @override
  Future<void> platformCallHandler(MethodCall call) {
    // TODO: implement platformCallHandler
    throw UnimplementedError();
  }

  @override
  // TODO: implement pushActionSink
  Sink get pushActionSink => throw UnimplementedError();

  @override
  // TODO: implement pushActionStream
  Stream<PushPayload> get pushActionStream => throw UnimplementedError();

  @override
  // TODO: implement pushSink
  Sink get pushSink => throw UnimplementedError();

  @override
  // TODO: implement pushStream
  Stream<PushPayload> get pushStream => throw UnimplementedError();

  @override
  Future<void> setSecureToken(String userId, String secureToken) {
    // TODO: implement setSecureToken
    throw UnimplementedError();
  }

  @override
  void setUpInAppCallbacks(
      MessageHandlerInAppClick onInAppClick,
      MessageHandler onInAppShown,
      MessageHandler onInAppDismiss,
      MessageHandler onInAppPrepared) {
    // TODO: implement setUpInAppCallbacks
  }

  @override
  void setUpPushCallbacks(MessageHandlerPushClick onPushClick,
      MessageHandlerPushClick onPushActionClick) {
    // TODO: implement setUpPushCallbacks
  }

  @override
  Future<void> setUserAttribute(String attributeName, userAttributeValue) {
    // TODO: implement setUserAttribute
    throw UnimplementedError();
  }

  @override
  Future<void> setUserAttributes(Map userAttributeValue) {
    // TODO: implement setUserAttributes
    throw UnimplementedError();
  }

  @override
  Future<void> setUserBirthDate(String birthDate) {
    // TODO: implement setUserBirthDate
    throw UnimplementedError();
  }

  @override
  Future<void> setUserCompany(String company) {
    // TODO: implement setUserCompany
    throw UnimplementedError();
  }

  @override
  Future<void> setUserDevicePushOptIn(bool status) {
    // TODO: implement setUserDevicePushOptIn
    throw UnimplementedError();
  }

  @override
  Future<void> setUserEmail(String email) {
    // TODO: implement setUserEmail
    throw UnimplementedError();
  }

  @override
  Future<void> setUserFirstName(String firstName) {
    // TODO: implement setUserFirstName
    throw UnimplementedError();
  }

  @override
  Future<void> setUserGender(String gender) {
    // TODO: implement setUserGender
    throw UnimplementedError();
  }

  @override
  Future<void> setUserHashedEmail(String email) {
    // TODO: implement setUserHashedEmail
    throw UnimplementedError();
  }

  @override
  Future<void> setUserHashedPhone(String phone) {
    // TODO: implement setUserHashedPhone
    throw UnimplementedError();
  }

  @override
  Future<void> setUserLastName(String lastName) {
    // TODO: implement setUserLastName
    throw UnimplementedError();
  }

  @override
  Future<void> setUserLocation(double lat, double lng) {
    // TODO: implement setUserLocation
    throw UnimplementedError();
  }

  @override
  Future<void> setUserOptIn(String channel, bool optIn) {
    // TODO: implement setUserOptIn
    throw UnimplementedError();
  }

  @override
  Future<void> setUserPhone(String phone) {
    // TODO: implement setUserPhone
    throw UnimplementedError();
  }

  @override
  Future<void> startGAIDTracking() {
    // TODO: implement startGAIDTracking
    throw UnimplementedError();
  }

  @override
  void tokenInvalidatedCallback(MessageHandler onTokenInvalidated) {
    // TODO: implement tokenInvalidatedCallback
  }

  @override
  // TODO: implement trackDeeplinkStream
  Stream<String?> get trackDeeplinkStream => throw UnimplementedError();

  @override
  // TODO: implement trackDeeplinkURLStreamSink
  Sink get trackDeeplinkURLStreamSink => throw UnimplementedError();

  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? attributes]) {
    // TODO: implement trackEvent
    throw UnimplementedError();
  }

  @override
  Future<void> trackScreen(String eventName,
      [Map<String, dynamic>? screenData]) {
    // TODO: implement trackScreen
    throw UnimplementedError();
  }

  @override
  Future<void> userLogin(String userId, [String? secureToken]) {
    // TODO: implement userLogin
    throw UnimplementedError();
  }

  @override
  Future<void> userLogout() {
    Logger.d("Not available");
    return Future.value(null);
  }
}

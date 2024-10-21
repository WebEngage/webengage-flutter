import 'dart:html';
import 'dart:js_util' as js_util;

import 'package:flutter/src/services/message_codec.dart';
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';
import 'package:webengage_flutter_web/src/extension.dart';
import 'package:webengage_flutter_web/src/utils/Utils.dart';
import 'package:webengage_flutter_web/src/utils/constants.dart';

class WebengageFlutterWeb extends MethodChannelWebEngageFlutter {
  var webengage, user;

  static void registerWith([Object? registrar]) {
    WebEngageFlutterPlatform.instance = WebengageFlutterWeb();
  }

  @override
  void init() {
    webEngageInitialize();
    _handleCallbacks();
  }

  void _handleCallbacks() {
    var notification =
        js_util.getProperty(webengage, WEB_METHOD_NAME_NOTIFICATION);
    if (notification != null) {
      js_util.callMethod(notification, WEB_METHOD_NAME_NOTIFICATION_ON_CLICK, [
        js_util.allowInterop((data) {
          var object = convertJsObjectToMap(data);
          //TODO : ID
          if (onInAppClick != null) {
            onInAppClick!(object, "");
          }
          print(object);
        })
      ]);
      js_util.callMethod(notification, WEB_METHOD_NAME_NOTIFICATION_ON_OPEN, [
        js_util.allowInterop((data) {
          var object = convertJsObjectToMap(data);
          if (onInAppShown != null) {
            onInAppShown!(object);
          }
        })
      ]);
      js_util.callMethod(notification, WEB_METHOD_NAME_NOTIFICATION_ON_CLOSE, [
        js_util.allowInterop((data) {
          print("data $data");
          var object = convertJsObjectToMap(data);
          if (onInAppDismiss != null) {
            onInAppDismiss!(object);
          }
        })
      ]);
    }
  }

  void webEngageInitialize() {
    webengage = js_util.getProperty(window, WEB_WEBENGAGE);
    user = js_util.getProperty(webengage, WEB_METHOD_NAME_USER);
  }

  @override
  Future<void> platformCallHandler(MethodCall call) {
    // TODO: implement platformCallHandler
    throw UnimplementedError();
  }

  @override
  @override
  Future<void> setSecureToken(String userId, String secureToken) {
    print("$userId $secureToken");
    this.performUserAction(WEB_METHOD_NAME_USER_LOGIN, [userId, secureToken]);
    return Future.value();
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
    this.performUserAttributeAction([attributeName, userAttributeValue]);
    return Future.value();
  }

  @override
  Future<void> setUserAttributes(Map userAttributeValue) {
    //TODO : need to check
    this.performUserAttributeAction(userAttributeValue);
    return Future.value();
  }

  @override
  Future<void> setUserBirthDate(String birthDate) {
    this.performUserAttributeAction([WEB_ATTRIBUTE_NAME_BIRTH_DATE, birthDate]);
    return Future.value();
  }

  @override
  Future<void> setUserCompany(String company) {
    this.performUserAttributeAction([WEB_ATTRIBUTE_NAME_COMPANY, company]);
    return Future.value();
  }

  @override
  Future<void> setUserDevicePushOptIn(bool status) {
    this.performUserAttributeAction([WEB_ATTRIBUTE_NAME_PUSH_OPT_IN, status]);
    return Future.value();
  }

  @override
  Future<void> setUserEmail(String email) {
    this.performUserAttributeAction([WEB_ATTRIBUTE_NAME_EMAIL, email]);
    return Future.value();
  }

  @override
  Future<void> setUserFirstName(String firstName) {
    this.performUserAttributeAction([WEB_ATTRIBUTE_NAME_FIRST_NAME, firstName]);
    return Future.value();
  }

  @override
  Future<void> setUserGender(String gender) {
    this.performUserAttributeAction([WEB_ATTRIBUTE_NAME_GENDER, gender]);
    return Future.value();
  }

  @override
  Future<void> setUserHashedEmail(String email) {
    this.performUserAttributeAction([WEB_ATTRIBUTE_NAME_HASH_EMAIL, email]);
    return Future.value();
  }

  @override
  Future<void> setUserHashedPhone(String phone) {
    this.performUserAttributeAction([WEB_ATTRIBUTE_NAME_HASH_PHONE, phone]);
    return Future.value();
  }

  @override
  Future<void> setUserLastName(String lastName) {
    this.performUserAttributeAction([WEB_ATTRIBUTE_NAME_LAST_NAME, lastName]);
    return Future.value();
  }

  @override
  Future<void> setUserLocation(double lat, double lng) {
    // TODO : how to pass it
    return Future.value();
  }

  @override
  Future<void> setUserOptIn(String channel, bool optIn) {
    this.performUserAttributeAction([channel, optIn]);
    return Future.value();
  }

  @override
  Future<void> setUserPhone(String phone) {
    this.performUserAttributeAction([WEB_ATTRIBUTE_NAME_PHONE, phone]);
    return Future.value();
  }

  @override
  Future<void> startGAIDTracking() {
    Logger.e("startGAIDTracking : : Not supported in Web Platform");
    return Future.value();
  }

  @override
  void tokenInvalidatedCallback(MessageHandler onTokenInvalidated) {
    // TODO: implement tokenInvalidatedCallback
  }

  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? attributes]) {
    this.performTrackEvent(eventName, attributes);
    return Future.value();
  }

  @override
  Future<void> trackScreen(String screenName,
      [Map<String, dynamic>? screenData]) {
    this.performTrackScreen(screenName, screenData);
    return Future.value();
  }

  @override
  Future<void> userLogin(String userId, [String? secureToken]) {
    this.performUserAction(WEB_METHOD_NAME_USER_LOGIN, [userId, secureToken]);
    return Future.value();
  }

  @override
  Future<void> userLogout() {
    this.performUserAction(WEB_METHOD_NAME_USER_LOGOUT, []);
    return Future.value();
  }
}

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

import '../utils/we_constants.dart';
import '../utils/we_utils.dart';

class WEWebImplementation extends WEWeb {
  List<Function> _onReadyCallbacks = [];

  WEWebImplementation();

  @override
  void handleSurveyEvent(WESurveyEventType eventType, callback) {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    JSObject? survey = instance![WEB_METHOD_NAME_SURVEY] as JSObject?;
    if (survey != null) {
      _addCallback(survey, eventType.name, callback);
    }
  }

  @override
  void onWebEngageReady(Function callback) {
    _onReadyCallbacks.add(callback);
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    JSAny? onReady = instance!['onReady'];

    if (onReady != null && _onReadyCallbacks.length == 1) {
      instance.callMethodVarArgs('onReady'.toJS, [
        (() {
          WELogger.w("onWebEngageReady");
          for (var cb in _onReadyCallbacks) {
            cb();
          }
        }).toJS
      ]);
    }
  }

  @override
  void setNotificationOption(optionKey, value) {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    JSObject? notification =
        instance![WEB_METHOD_NAME_NOTIFICATION] as JSObject?;
    if (notification != null) {
      notification.callMethodVarArgs(WEB_METHOD_NAME_OPTIONS.toJS,
          [(optionKey as Object).jsify(), (value as Object).jsify()]);
    }
  }

  @override
  void setOption(optionKey, value) {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    instance!.callMethodVarArgs(WEB_METHOD_NAME_OPTIONS.toJS,
        [(optionKey as Object).jsify(), (value as Object).jsify()]);
  }

  @override
  void setSurveyOption(optionKey, value) {}

  @override
  void handleNotificationEvent(WENotificationActionType eventType, callback) {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    JSObject? notification =
        instance![WEB_METHOD_NAME_NOTIFICATION] as JSObject?;
    if (notification != null) {
      _addCallback(notification, eventType.name, callback);
    }
  }

  void _addCallback(
      JSObject type, String methodName, Function(dynamic) callback) {
    type.callMethodVarArgs(methodName.toJS, [
      ((JSAny? data) {
        var object = convertJsObjectToMap(data);
        callback(object);
      }).toJS
    ]);
  }

  @override
  void onSessionStarted(Function callback) {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    JSAny? sessionStarted =
        instance![WEB_METHOD_NAME_ON_SESSION_STARTED];
    if (sessionStarted != null) {
      instance.callMethodVarArgs(
          WEB_METHOD_NAME_ON_SESSION_STARTED.toJS, [(() {
            callback();
          }).toJS]);
    } else {
      WELogger.w(
          "WebEngage object is null or onSessionStarted method not available.");
    }
  }

  @override
  void handleWebPushEvent(WEWebPushEvent eventType, Function callback) {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    var eventMap = {
      WEWebPushEvent.onWindowViewed: 'webpush.onWindowViewed',
      WEWebPushEvent.onWindowAllowed: 'webpush.onWindowAllowed',
      WEWebPushEvent.onWindowDenied: 'webpush.onWindowDenied',
      WEWebPushEvent.onPushRegistered: 'webpush.onPushRegistered',
      WEWebPushEvent.onPushUnregistered: 'webpush.onPushUnregistered',
    };

    var eventName = eventMap[eventType];
    if (eventName != null) {
      instance!.callMethodVarArgs(
          WEB_METHOD_NAME_OPTIONS.toJS, [eventName.toJS, (() {
            callback();
          }).toJS]);
    } else {
      WELogger.w("WebEngage object is null or options method not available.");
    }
  }

  @override
  void promptPushNotification() {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    JSObject? webpush = instance!['webpush'] as JSObject?;
    if (webpush != null) {
      webpush.callMethodVarArgs('prompt'.toJS, []);
    }
  }

  @override
  void onPushSubscribe(Function callback) {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    JSObject? webpush = instance!['webpush'] as JSObject?;
    if (webpush != null) {
      webpush.callMethodVarArgs('onSubscribe'.toJS, [(() {
        callback();
      }).toJS]);
    }
  }

  @override
  void checkSubscriptionStatus(Function(bool) callback) {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    JSObject? webpush = instance!['webpush'] as JSObject?;
    if (webpush != null) {
      JSAny? subscribed = webpush.callMethodVarArgs('isSubscribed'.toJS, []);
      WELogger.e("Checking... $subscribed");
      if (subscribed != null) {
        callback((subscribed as JSBoolean).toDart);
      } else {
        callback(false);
      }
    }
  }

  @override
  void checkPushNotificationSupport(Function(bool) callback) {
    var instance = WEWebUtils().getWebEngageInstance();
    if (!WEWebUtils().isWebEngageAdded()) {
      return;
    }
    JSObject? webpush = instance!['webpush'] as JSObject?;
    if (webpush != null) {
      webpush.callMethodVarArgs('isPushNotificationsSupported'.toJS, [
        ((JSBoolean result) {
          callback(result.toDart);
        }).toJS
      ]);
    }
  }
}

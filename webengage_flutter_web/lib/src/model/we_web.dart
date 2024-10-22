import 'dart:js_util' as js_util;

import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

import '../utils/Utils.dart';
import '../utils/constants.dart';

class WEWebImplementation extends WEWeb {
  final dynamic webengage;
  List<Function> _onReadyCallbacks = [];

  WEWebImplementation(this.webengage);

  @override
  void handleSurveyEvent(SurveyEventType eventType, callback) {
    var survey = js_util.getProperty(webengage, WEB_METHOD_NAME_SURVEY);
    if (survey != null) {
      _addCallback(survey, eventType.name, callback);
    }
  }

  @override
  void onWebEngageReady(Function callback) {
    _onReadyCallbacks.add(callback);
    var onReady = js_util.getProperty(webengage, 'onReady');

    if (onReady != null && _onReadyCallbacks.length == 1) {
      // Ensuring we only bind `onReady` once
      js_util.callMethod(webengage, 'onReady', [
        js_util.allowInterop(() {
          Logger.w("onWebEngageReady");
          for (var cb in _onReadyCallbacks) {
            cb(); // Trigger all registered callbacks
          }
        })
      ]);
    }
  }

  @override
  void setNotificationOption(optionKey, value) {}

  @override
  void setOption(optionKey, value) {
    js_util.callMethod(webengage, WEB_METHOD_NAME_OPTIONS, [optionKey, value]);
  }

  @override
  void setSurveyOption(optionKey, value) {}

  @override
  void handleNotificationEvent(NotificationEventType eventType, callback) {
    var notification =
        js_util.getProperty(webengage, WEB_METHOD_NAME_NOTIFICATION);
    if (notification != null) {
      _addCallback(notification, eventType.name, callback);
    }
  }

  void _addCallback(
      dynamic type, String methodName, Function(dynamic) callback) {
    js_util.callMethod(type, methodName, [
      js_util.allowInterop((data) {
        var object = convertJsObjectToMap(data);
        callback(object);
      })
    ]);
  }

  @override
  void onSessionStarted(Function callback) {
    var sessionStarted =
        js_util.getProperty(webengage, WEB_METHOD_NAME_ON_SESSION_STARTED);
    if (sessionStarted != null) {
      js_util.callMethod(webengage, WEB_METHOD_NAME_ON_SESSION_STARTED,
          [js_util.allowInterop(callback)]);
    } else {
      Logger.w(
          "WebEngage object is null or onSessionStarted method not available.");
    }
  }

  @override
  void handleWebPushEvent(WebPushEventType eventType, Function callback) {
    var eventMap = {
      WebPushEventType.onWindowViewed: 'webpush.onWindowViewed',
      WebPushEventType.onWindowAllowed: 'webpush.onWindowAllowed',
      WebPushEventType.onWindowDenied: 'webpush.onWindowDenied',
      WebPushEventType.onPushRegistered: 'webpush.onPushRegistered',
      WebPushEventType.onPushUnregistered: 'webpush.onPushUnregistered',
    };

    var eventName = eventMap[eventType];
    if (eventName != null) {
      js_util.callMethod(webengage, WEB_METHOD_NAME_OPTIONS,
          [eventName, js_util.allowInterop(callback)]);
    } else {
      Logger.w("WebEngage object is null or options method not available.");
    }
  }

  @override
  void promptPushNotification() {
    var webpush = js_util.getProperty(webengage, 'webpush');
    if (webpush != null) {
      js_util.callMethod(webpush, 'prompt', []);
    }
  }

  @override
  void onPushSubscribe(Function callback) {
    Logger.w("onPushSubscribe calling");
    var webpush = js_util.getProperty(webengage, 'webpush');
    if (webpush != null) {
      js_util
          .callMethod(webpush, 'onSubscribe', [js_util.allowInterop(callback)]);
    }
  }

  @override
  void checkSubscriptionStatus(Function(bool) callback) {
    Logger.w("Checking... checkSubscriptionStatus");
    Logger.w("Checking... onWebEngageReady");
    var webpush = js_util.getProperty(webengage, 'webpush');
    if (webpush != null) {
      var subscribed = js_util.callMethod(webpush, 'isSubscribed', []);
      Logger.e("Checking... $subscribed");
      callback(subscribed);
    }
  }

  @override
  void checkPushNotificationSupport(Function(bool) callback) {
    var webpush = js_util.getProperty(webengage, 'webpush');
    if (webpush != null) {
      js_util.callMethod(webpush, 'isPushNotificationsSupported',
          [js_util.allowInterop(callback)]);
    }
  }
}

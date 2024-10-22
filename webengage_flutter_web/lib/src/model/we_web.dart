import 'dart:js_util' as js_util;

import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

import '../utils/Utils.dart';
import '../utils/constants.dart';

class WEWebImplementation extends WEWeb {
  var webengage;

  WEWebImplementation(webengage) {
    this.webengage = webengage;
  }

  @override
  //onOpen,onClose,onSubmit,onComplete
  void handleSurveyEvent(SurveyEventType eventType, callback) {
    var survey = js_util.getProperty(webengage, WEB_METHOD_NAME_SURVEY);

    if (survey != null) {
      _addCallback(survey, eventType.name, (data) {
        var object = convertJsObjectToMap(data);
        callback(object);
      });
    }
  }

  @override
  void onWebEngageReady(callback) {}

  @override
  void setNotificationOption(optionKey, value) {}

  @override
  void setOption(optionKey, value) {}

  @override
  void setSurveyOption(optionKey, value) {}

  @override
  //onOpen,onClose,onClick
  void handleNotificationEvent(NotificationEventType eventType, callback) {
    var notification =
        js_util.getProperty(webengage, WEB_METHOD_NAME_NOTIFICATION);

    if (notification != null) {
      _addCallback(notification, eventType.name, (data) {
        var object = convertJsObjectToMap(data);
        callback(object);
      });
    }
  }

  void _addCallback(
      dynamic type, String methodName, Function(dynamic) callback) {
    js_util.callMethod(type, methodName, [js_util.allowInterop(callback)]);
  }

  @override
  void onSessionStarted(Function callback) {
    var webEngageObj =
        js_util.getProperty(webengage, WEB_METHOD_NAME_ON_SESSION_STARTED);

    if (webEngageObj != null) {
      js_util.callMethod(webengage, WEB_METHOD_NAME_ON_SESSION_STARTED,
          [js_util.allowInterop(callback)]);
    } else {
      Logger.w(
          "WebEngage object is null or onSessionStarted method not available.");
    }
  }

  @override
  void handleWebPushEvent(WebPushEventType eventType, Function callback) {
    var webEngageObj = js_util.getProperty(webengage, WEB_METHOD_NAME_OPTIONS);

    if (webEngageObj != null) {
      String eventName;

      // Map enum to corresponding WebEngage event name
      switch (eventType) {
        case WebPushEventType.onWindowViewed:
          eventName = 'webpush.onWindowViewed';
          break;
        case WebPushEventType.onWindowAllowed:
          eventName = 'webpush.onWindowAllowed';
          break;
        case WebPushEventType.onWindowDenied:
          eventName = 'webpush.onWindowDenied';
          break;
        case WebPushEventType.onPushRegistered:
          eventName = 'webpush.onPushRegistered';
          break;
        case WebPushEventType.onPushUnregistered:
          eventName = 'webpush.onPushUnregistered';
          break;
      }

      // Call the corresponding WebEngage method
      js_util.callMethod(webengage, WEB_METHOD_NAME_OPTIONS,
          [eventName, js_util.allowInterop(callback)]);
    } else {
      Logger.w("WebEngage object is null or options method not available.");
    }
  }
}

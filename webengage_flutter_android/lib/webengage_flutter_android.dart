import 'dart:async';

import 'package:flutter/services.dart' hide MessageHandler;
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

import '/src/we_extension/we_extension.dart';

class WEFlutterAndroid extends WEMethodChannel {
  static void registerWith() {
    WEPlatformInterface.instance = WEFlutterAndroid();
  }

  @override
  void init() {
    methodChannel.setMethodCallHandler(platformCallHandler);
    methodChannel.invokeMethod(methodInitialise);
  }

  @override
  Future<void> platformCallHandler(MethodCall call) {
    switch (call.method) {
      case callbackOnPushClickV2:
      case callbackOnPushActionClickV2:
        handlePushClickV2(call);
        break;

      case callbackOnPushClick:
      case callbackOnPushActionClick:
        handlePushClick(call);
        break;

      case callbackOnInAppClicked:
        handleInAppClick(call);
        break;

      case callbackOnInAppShown:
        handleCallbackFunctions(call, onInAppShown);
        break;

      case callbackOnInAppDismissed:
        handleCallbackFunctions(call, onInAppDismiss);
        break;

      case callbackOnInAppPrepared:
        handleCallbackFunctions(call, onInAppPrepared);
        break;

      case callbackOnTokenInvalidated:
        handleCallbackFunctions(call, onTokenInvalidated);
        break;

      case callbackOnAnonymousIdChanged:
        onAnonymousIdChanged(call);
        break;

      case METHOD_TRACK_DEEPLINK_URL:
        trackDeeplinkCallback(call);
        break;
    }
    return Future.value();
  }

  @override
  void onPushMessageReceive(Map<String, dynamic>? data) {
    methodChannel
        .invokeMethod(METHOD_NAME_ON_PUSH_MESSAGE_RECEIVED, {"data": data});
  }

  @override
  void setPushToken(String pushToken) {
    methodChannel.invokeMethod(METHOD_NAME_ON_PUSH_TOKEN, pushToken);
  }
}

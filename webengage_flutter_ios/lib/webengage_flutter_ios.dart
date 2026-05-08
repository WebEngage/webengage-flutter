import 'dart:async';

import 'package:flutter/services.dart' hide MessageHandler;
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

import 'src/we_extension/we_extension.dart';

class WEFlutterIos extends WEMethodChannel {
  static void registerWith() {
    WEPlatformInterface.instance = WEFlutterIos();
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
  Future<void> setUserDevicePushOptIn(bool status) async {
    WELogger.i("setUserDevicePushOptIn $IOS_METHOD_NOT_SUPPORTED");
    return Future.value();
  }

  @override
  Future<void> startGAIDTracking() async {
    WELogger.i("startGAIDTracking $IOS_METHOD_NOT_SUPPORTED");
    return Future.value();
  }

  @override
  void onPushMessageReceive(Map<String, dynamic>? data) {
    WELogger.i("onPushMessageReceive $IOS_METHOD_NOT_SUPPORTED");
  }

  @override
  void setPushToken(String pushToken) {
    WELogger.i("setPushToken $IOS_METHOD_NOT_SUPPORTED");
  }
}

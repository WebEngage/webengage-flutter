import 'package:flutter/services.dart' hide MessageHandler;
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

import '../../webengage_flutter_ios.dart';

extension WEChannelExt on WEFlutterIos {
  void handlePushClick(MethodCall call) {
    Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
    String? deepLink = message![DEEPLINK];
    Map<String, dynamic>? newPayload = call.arguments.cast<String, dynamic>();
    PushPayload pushPayload = PushPayload()
      ..deepLink = deepLink
      ..payload = newPayload;
    if (call.method == callbackOnPushClick) {
      pushClickStream.sink.add(pushPayload);
    } else if (call.method == callbackOnPushActionClick) {
      pushActionClickStream.sink.add(pushPayload);
    }
  }

  void handleInAppClick(MethodCall call) {
    Map<String, dynamic>? message = call.arguments?.cast<String, dynamic>();
    if (onInAppClick != null && message != null) {
      String? selectedActionId = message[SELECTED_ACTION_ID];
      onInAppClick!(call.arguments.cast<String, dynamic>(), selectedActionId);
    }
  }

  void handleCallbackFunctions(MethodCall call, MessageHandler? callback) {
    Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
    if (callback != null && message != null) {
      callback(call.arguments.cast<String, dynamic>());
    }
  }

  void onAnonymousIdChanged(MethodCall call) {
    Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
    anonymousIDStream.sink.add(message);
  }

  void trackDeeplinkCallback(MethodCall call) {
    String? locationLink = call.arguments;
    trackDeeplinkURLStream.sink.add(locationLink);
  }
}

import 'package:flutter/services.dart' hide MessageHandler;
import 'package:webengage_flutter_platform_interface/webengage_flutter_platform_interface.dart';

import '../webengage_flutter_android.dart';

extension WebEngageChannelExt on WebEngageFlutterAndroid {
  void handlePushClick(MethodCall call) {
    Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
    String? deepLink = message?[PAYLOAD][URI];
    Map<String, dynamic>? newPayload =
        message?[PAYLOAD].cast<String, dynamic>();

    if (message != null) {
      PushPayload pushPayload = PushPayload()
        ..deepLink = deepLink
        ..payload = newPayload;

      final isPushClick = call.method == callbackOnPushClick;
      final stream = isPushClick ? pushClickStream : pushActionClickStream;
      final callback = isPushClick ? onPushClick : onPushActionClick;

      stream.sink.add(pushPayload);
      if (callback != null) {
        callback(newPayload, deepLink);
      }
    }
  }

  void handleInAppClick(MethodCall call) {
    Map<String, dynamic>? message = call.arguments?.cast<String, dynamic>();
    if (onInAppClick != null && message != null) {
      String? selectedActionId = message[PAYLOAD][SELECTED_ACTION_ID];
      Map<String, dynamic>? newPayload =
          message[PAYLOAD].cast<String, dynamic>();
      onInAppClick!(newPayload, selectedActionId);
    }
  }

  void handleCallbackFunctions(MethodCall call, MessageHandler? callback) {
    Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
    if (callback != null && message != null) {
      Map<String, dynamic>? newPayload =
          message[PAYLOAD].cast<String, dynamic>();
      callback(newPayload);
    }
  }

  void onAnonymousIdChanged(MethodCall call) {
    Map<String, dynamic>? message = call.arguments.cast<String, dynamic>();
    anonymousIDStream.sink.add(message?[PAYLOAD].cast<String, dynamic>());
  }

  void trackDeeplinkCallback(MethodCall call) {
    String? locationLink = call.arguments;
    trackDeeplinkURLStream.sink.add(locationLink);
  }
}

import 'package:webengage_flutter/PushPayload.dart';

typedef void WEMessageHandler(Map<String, dynamic>? message);
typedef void WEMessageHandlerInAppClick(Map<String, dynamic>? message, String? s);
typedef void WEMessageHandlerPushClick(Map<String, dynamic>? message, String? s);
typedef void WEPushNotificationClickedHandler(PushPayload pushPayload);


import 'package:flutter/services.dart';

import '../../webengage_flutter_platform_interface.dart';

extension WEChannelExt on WEMethodChannel {
  void handlePushClickV2(MethodCall call) {
    try {
      final payload = call.arguments as Map<String, dynamic>?;
      final message = payload?["payload"] as Map<String, dynamic>?;
      final deepLink = message?[DEEPLINK] as String?;
      final customData = message?["data"] as Map<String, dynamic>?;

      if (onWEPushNotificationClick != null && deepLink != null) {
        onWEPushNotificationClick!(
          PushPayload()
            ..deepLink = deepLink
            ..customData = customData,
        );
      }
    } catch (e) {
      // Optionally handle errors here, e.g., logging
    }
  }
}

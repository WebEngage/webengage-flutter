import 'package:flutter/services.dart';

import '../../webengage_flutter_platform_interface.dart';

extension WEChannelExt on WEMethodChannel {
  void handlePushClickV2(MethodCall call) {
    try {
      // Safely cast call.arguments to Map<String, dynamic>
      final payload =
          (call.arguments as Map<Object?, Object?>?)?.cast<String, dynamic>();
      final message = payload?["payload"] as Map<Object?, Object?>?;
      final deepLink = message?.cast<String, dynamic>()[DEEPLINK] as String?;
      final customData =
          message?.cast<String, dynamic>()["data"] as Map<Object?, Object?>?;

      if (onWEPushNotificationClick != null && deepLink != null) {
        onWEPushNotificationClick!(
          PushPayload()
            ..deepLink = deepLink
            ..customData = customData?.cast<String, dynamic>(),
        );
      }
    } catch (e) {}
  }
}

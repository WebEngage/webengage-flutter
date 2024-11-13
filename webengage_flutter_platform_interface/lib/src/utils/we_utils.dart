import 'dart:convert';

import 'package:webengage_flutter_platform_interface/src/utils/we_logger.dart';

class WEUtils {
  static String? getInAppDeeplink(
      Map<String, dynamic>? payload, String? actionEId) {
    try {
      final actions = payload?['actions'];
      WELogger.i("actions = $actions");

      List<dynamic>? actionList;

      if (actions is String) {
        // Parse actions if it is a JSON string
        actionList = jsonDecode(actions) as List<dynamic>?;
      } else if (actions is List<dynamic>) {
        actionList = actions;
      }

      if (actionList != null) {
        return actionList.firstWhere(
          (action) => action['actionEId'] == actionEId,
          orElse: () => null,
        )?['actionLink'];
      }

      WELogger.e(
          "getInAppDeeplink: actions is neither a list nor a valid JSON string");
    } catch (e) {
      WELogger.e("getInAppDeeplink encountered an error: $e");
    }

    return null;
  }
}

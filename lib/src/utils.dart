class WEUtils {
  static String? getInAppDeeplink(Map<String, dynamic>? payload, String? actionEId) {
    if (actionEId == null) return null; // Return empty string if actionEId is null
    if (payload == null) return null; // Return empty string if payload is null

    List<dynamic>? actions = payload['actions'];

    if (actions != null) {
      for (var action in actions) {
        if (action['actionEId'] == actionEId) {
          return action['actionLink'];
        }
      }
    }
    return null; // Return empty string if actionEId is not found or actions list is null
  }
}

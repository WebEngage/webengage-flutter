class WEUtils {
  static String? getInAppDeeplink(
      Map<String, dynamic>? payload, String? actionEId) {
    if (actionEId == null || payload == null) return null;

    return (payload['actions'] as List<dynamic>?)?.firstWhere(
      (action) => action['actionEId'] == actionEId,
      orElse: () => null,
    )?['actionLink'];
  }
}

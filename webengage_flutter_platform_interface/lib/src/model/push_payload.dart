class PushPayload {
  String? deepLink;
  Map<String, dynamic>? payload;

  /// Returns a string representation of the push payload.
  @override
  String toString() {
    return "{\nPayload: $payload,\n deepLink: $deepLink\n}";
  }
}

class PushPayload {
  String deepLink;
  Map<String, dynamic> payload;
  @override
  String toString() {
    // TODO: implement toString
    return "{\nPayload: $payload,\n deepLink: $deepLink\n}";
  }
}
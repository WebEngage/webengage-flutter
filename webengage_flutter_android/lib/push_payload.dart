// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

/// Data class representing a push notification payload.
class PushPayload {
  String? deepLink;
  Map<String, dynamic>? payload;

  /// Returns a string representation of the push payload.
  @override
  String toString() {
    return "{\nPayload: $payload,\n deepLink: $deepLink\n}";
  }
}

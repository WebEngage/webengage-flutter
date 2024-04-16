// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

class PushPayload {
  String? deepLink;
  Map<String, dynamic>? payload;
  @override
  String toString() {
    // TODO: implement toString
    return "{\nPayload: $payload,\n deepLink: $deepLink\n}";
  }
}
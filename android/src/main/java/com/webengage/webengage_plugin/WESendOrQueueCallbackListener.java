// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

package com.webengage.webengage_plugin;

import java.util.Map;

public interface WESendOrQueueCallbackListener {
    void sendOrQueueCallback(String methodName, Map<String, Object> message);
}

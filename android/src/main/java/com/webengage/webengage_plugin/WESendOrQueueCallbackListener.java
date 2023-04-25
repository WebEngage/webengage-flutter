package com.webengage.webengage_plugin;

import java.util.Map;

public interface WESendOrQueueCallbackListener {
    void sendOrQueueCallback(String methodName, Map<String, Object> message);
}

// Copyright 2020 WebEngage
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License, which can be
// found in the LICENSE file.

package com.webengage.webengage_plugin;

import java.util.Map;

/**
 * Interface for a callback listener used to send or queue callbacks.
 */
public interface WESendOrQueueCallbackListener {
    /**
     * Sends or queues a callback with the specified method name and message.
     *
     * @param methodName The name of the method associated with the callback.
     * @param message    The message to be sent along with the callback.
     */
    void sendOrQueueCallback(String methodName, Map<String, Object> message);
}

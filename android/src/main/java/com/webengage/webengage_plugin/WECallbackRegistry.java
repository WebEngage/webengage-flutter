package com.webengage.webengage_plugin;

import android.util.Log;

import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

public class WECallbackRegistry {

    private WECallbackRegistry(){}

    private static volatile WECallbackRegistry instance = null;

    public static WECallbackRegistry getInstance() {
        if (instance != null) {
            return instance;
        }
        synchronized (WECallbackRegistry.class) {
            if (instance == null) {
                instance = new WECallbackRegistry();
            }
        }
        return instance;
    }

    private Set<WESendOrQueueCallbackListener> listeners;
    private  final Map<String, Map<String, Object>> messageQueue =
            Collections.synchronizedMap(new LinkedHashMap<>());

    public void register(WESendOrQueueCallbackListener listener) {
        if (listeners == null) {
            listeners = new HashSet<>();
        }
        listeners.add(listener);
        checkQueue();
    }



    public void unRegister(WESendOrQueueCallbackListener listener) {
        if (listeners == null) {
            return;
        }
        listeners.remove(listener);
    }

    public void  passCallback(String methodName, Map<String, Object> message){
        if (listeners != null && listeners.size() > 0) {
            for (WESendOrQueueCallbackListener listener : listeners)
                listener.sendOrQueueCallback(methodName, message);
        }else{
            messageQueue.put(methodName, message);
        }
    }

    private void checkQueue(){
        for (Map.Entry<String, Map<String, Object>> entry : messageQueue.entrySet()) {
            passCallback(entry.getKey(), entry.getValue());
        }
        messageQueue.clear();
    }

}

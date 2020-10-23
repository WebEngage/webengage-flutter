package com.webengage.webengage_plugin;

import android.os.Bundle;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class Utils {
    public static Map<String, Object> bundleToMap(Bundle bundle) {
        Map<String, Object> map = new HashMap<>();
        Set<String> keys = bundle.keySet();
        for (String key : keys) {
            Object value = bundle.get(key);
            if (value != null) {
                map.put(key, value);
            }
        }
        return map;
    }
}

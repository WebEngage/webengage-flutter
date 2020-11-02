package com.webengage.webengage_plugin;

import android.os.Bundle;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
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

    static Map<String, Object> jsonObjectToMap(JSONObject jsonObject) {
        Map<String, Object> stringObjectMap = new HashMap<>();
        String key;
        Object value;

        if (jsonObject != null) {
            Iterator iterator = jsonObject.keys();
            while (iterator.hasNext()) {
                key = iterator.next().toString();
                try {
                    value = jsonObject.get(key);
                } catch (JSONException ex) {
                    Log.e("WebengageError", "JSON to Map error", ex);
                    return stringObjectMap;
                }
                stringObjectMap.put(key, value.toString());
            }
        }
        return stringObjectMap;
    }
}

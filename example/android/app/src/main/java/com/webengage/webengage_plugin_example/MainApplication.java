package com.webengage.webengage_plugin_example;

import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;

import io.flutter.app.FlutterApplication;

public class MainApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        registerActivityLifecycleCallbacks(new WebEngageActivityLifeCycleCallbacks(this));
    }
}

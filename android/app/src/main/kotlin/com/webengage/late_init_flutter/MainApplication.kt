package com.webengage.late_init_flutter

import android.app.Application

/**
 * Custom Application class for the Flutter app.
 * Initializes SharedPreferencesManager and WebEngage SDK on app startup.
 */
public class MainApplication : Application() {

    /**
     * Called when the application is starting.
     * Initializes SharedPreferencesManager and attempts WebEngage SDK initialization.
     */
    override fun onCreate() {
        super.onCreate()
        SharedPreferencesManager.init(
            context = this as Application,
            preferenceName = "my_sdk_prefs"
        )
        WebEngageHelper.instance!!.initWebEngage(this as Application, null)
    }
}
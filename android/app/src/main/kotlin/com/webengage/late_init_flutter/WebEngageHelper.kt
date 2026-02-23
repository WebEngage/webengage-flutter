package com.webengage.late_init_flutter

import android.app.Activity
import android.app.Application
import com.webengage.sdk.android.Environment
import com.webengage.sdk.android.LocationTrackingStrategy
import com.webengage.sdk.android.WebEngage
import com.webengage.sdk.android.WebEngageConfig
import com.webengage.webengage_plugin.WebengageInitializer

/**
 * Singleton helper class for WebEngage SDK initialization.
 * Handles late initialization based on stored configuration.
 */
class WebEngageHelper private constructor() {

    /**
     * Initializes WebEngage SDK with stored configuration.
     * Retrieves license code and environment from SharedPreferences.
     *
     * @param context Application context
     * @param activityContext Activity context (optional, required for late init)
     */
    fun initWebEngage(
        context: Application?,
        activityContext: Activity?
    ) {

        if (isInitialized)
            return;

        val license_code = SharedPreferencesManager.getInstance()
            .getValue(SharedPreferencesManager.LICENSE_CODE, "") as String

        val env = SharedPreferencesManager.getInstance()!!
            .getValue(SharedPreferencesManager.ENV, "") as String

        android.util.Log.e("TAG", "initWebEngage: ${license_code} ${env}")
        if (license_code == null || license_code.toString().length == 0)
            return


        val webEngageConfig = WebEngageConfig.Builder()
            .setWebEngageKey(license_code)
            .setEnvironment(mapToEnvironment(env))
            .setAutoGCMRegistrationFlag(false)
            .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
            .setDebugMode(true) // only in development mode
            .build()
        isInitialized = true
        // Below two lines are required for late init - start
        if (activityContext != null) WebEngage.get().analytics().start(activityContext)
        // end
        WebengageInitializer.initialize(context, webEngageConfig)
    }


    companion object {
        /** Singleton instance of WebEngageHelper. */
        val instance = WebEngageHelper()
    }

    var isInitialized = false

    /**
     * Maps environment string to WebEngage Environment enum.
     *
     * @param env Environment identifier ("IN", "KSA", "US")
     * @return Corresponding Environment enum value
     */
    private fun mapToEnvironment(env: String?): Environment {
        return when (env?.uppercase()) {
            "IN" -> Environment.IN
            "KSA" -> Environment.KSA
            "US" -> Environment.US
            else -> Environment.US // safe fallback
        }
    }
}

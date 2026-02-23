package com.webengage.late_init_flutter
import android.app.Application
import android.content.Context

import android.content.SharedPreferences

/**
 * Thread-safe singleton manager for SharedPreferences operations.
 * Provides type-safe methods for storing and retrieving data.
 */
public class SharedPreferencesManager private constructor(
    context: Context,
    preferenceName: String
) {

    private val sharedPreferences: SharedPreferences =
        context.applicationContext.getSharedPreferences(
            preferenceName,
            Context.MODE_PRIVATE
        )

    /**
     * Stores a value in SharedPreferences.
     * Supports String, Int, Boolean, Float, Long types.
     * 
     * @param key The preference key
     * @param value The value to store (null removes the key)
     * @throws IllegalArgumentException if value type is unsupported
     */
    fun putValue(key: String, value: Any?) {
        with(sharedPreferences.edit()) {
            when (value) {
                is String? -> putString(key, value)
                is Int -> putInt(key, value)
                is Boolean -> putBoolean(key, value)
                is Float -> putFloat(key, value)
                is Long -> putLong(key, value)
                null -> remove(key)
                else -> throw IllegalArgumentException("Unsupported data type")
            }
            apply()
        }
    }

    /**
     * Retrieves a value from SharedPreferences.
     * 
     * @param key The preference key
     * @param defaultValue Default value if key doesn't exist
     * @return The stored value or defaultValue
     * @throws IllegalArgumentException if defaultValue type is unsupported
     */
    @Suppress("UNCHECKED_CAST")
    fun <T> getValue(key: String, defaultValue: T): T {
        return when (defaultValue) {
            is String? -> sharedPreferences.getString(key, defaultValue) as T
            is Int -> sharedPreferences.getInt(key, defaultValue) as T
            is Boolean -> sharedPreferences.getBoolean(key, defaultValue) as T
            is Float -> sharedPreferences.getFloat(key, defaultValue) as T
            is Long -> sharedPreferences.getLong(key, defaultValue) as T
            else -> throw IllegalArgumentException("Unsupported data type")
        }
    }

    /**
     * Removes a specific key from SharedPreferences.
     * 
     * @param key The preference key to remove
     */
    fun removeValue(key: String) {
        sharedPreferences.edit().remove(key).apply()
    }

    /**
     * Clears all data from SharedPreferences.
     */
    fun clear() {
        sharedPreferences.edit().clear().apply()
    }

    companion object {

        @Volatile
        private var instance: SharedPreferencesManager? = null

        /** Key for storing WebEngage license code. */
        const val LICENSE_CODE = "license_code"
        
        /** Key for storing environment identifier. */
        const val ENV = "env"

        /**
         * Initializes the SharedPreferencesManager singleton.
         * Call this ONLY once from Application class.
         * 
         * @param context Application context
         * @param preferenceName Name of the SharedPreferences file
         */
        fun init(context: Application, preferenceName: String = "app_prefs") {
            if (instance == null) {
                synchronized(this) {
                    if (instance == null) {
                        instance = SharedPreferencesManager(context, preferenceName)
                    }
                }
            }
        }

        /**
         * Returns the singleton instance.
         * 
         * @return SharedPreferencesManager instance
         * @throws IllegalStateException if init() hasn't been called
         */
        fun getInstance(): SharedPreferencesManager {
            return instance
                ?: throw IllegalStateException(
                    "SharedPreferencesManager is not initialized. Call init() in Application class."
                )
        }
    }
}

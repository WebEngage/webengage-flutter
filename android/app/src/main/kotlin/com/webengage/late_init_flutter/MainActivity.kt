package com.webengage.late_init_flutter

import android.app.Application
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * Main activity for the Flutter application.
 * Handles method channel communication between Flutter and native Android.
 */
class MainActivity : FlutterActivity() {

    /** Method channel name for Flutter-Android communication. */
    val F_CHANNEL: String = "flutter_method_channel"

    /**
     * Configures the Flutter engine and sets up method channel handlers.
     * Handles 'initWebEngage' and 'clearData' method calls from Flutter.
     */
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, F_CHANNEL)
            .setMethodCallHandler { call, result ->
                android.util.Log.e("TAG", "configureFlutterEngine: ${call.method}" )
                when (call.method) {

                    "initWebEngage" -> {
                        val args = call.arguments as? Map<String, Any?>

                        val licenseCode = args?.get("licenseCode") as? String
                        val env = args?.get("env") as? String

                        if (licenseCode.isNullOrEmpty() || env.isNullOrEmpty()) {
                            result.error(
                                "INVALID_ARGS",
                                "licenseCode or env is missing",
                                null
                            )
                            return@setMethodCallHandler
                        }

                        SharedPreferencesManager.getInstance().apply {
                            putValue(SharedPreferencesManager.LICENSE_CODE, licenseCode)
                            putValue(SharedPreferencesManager.ENV, env)
                        }

                        try {
                            // Initialize SDK
                            WebEngageHelper.instance!!
                                .initWebEngage(this.applicationContext as Application, this)

                            // Persist values


                            result.success(true)

                        } catch (e: Exception) {
                            result.error(
                                "INIT_FAILED",
                                e.message,
                                null
                            )
                        }
                    }

                    "clearData" -> {
                        SharedPreferencesManager.getInstance().apply {
                            removeValue(SharedPreferencesManager.LICENSE_CODE)
                            removeValue(SharedPreferencesManager.ENV)
                        }
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

}

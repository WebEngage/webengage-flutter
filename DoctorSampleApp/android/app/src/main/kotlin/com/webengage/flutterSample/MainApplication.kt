package com.webengage.flutterSample
import android.app.Application
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.FirebaseApp
import com.google.firebase.messaging.FirebaseMessaging
import com.webengage.sdk.android.WebEngage
import com.webengage.sdk.android.WebEngageConfig;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;

class MainApplication: Application() {

    override fun onCreate() {
        super.onCreate()
        val webEngageConfig = WebEngageConfig.Builder()
            .setWebEngageKey("~2024bb40")
            .setDebugMode(true) // only in development mode
            .build()
        registerActivityLifecycleCallbacks(
            WebEngageActivityLifeCycleCallbacks(
                this,
                webEngageConfig
            )
        )
        FirebaseMessaging.getInstance().token
            .addOnCompleteListener(OnCompleteListener { task ->
                if (!task.isSuccessful) {
                    return@OnCompleteListener
                }
                // Get new FCM registration token
                val token: String? = task.getResult()
                WebEngage.get().setRegistrationID(token)
            })

        FirebaseApp.initializeApp(applicationContext)
    }
}




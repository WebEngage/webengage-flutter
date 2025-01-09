import UIKit
import Flutter
import WebEngage
import webengage_flutter
import FirebaseMessaging
@main
@objc class AppDelegate: FlutterAppDelegate {
    var bridge:WebEngagePlugin? = nil
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Basic set up
        bridge = WebEngagePlugin()
          // Push notification delegates
        WebEngage.sharedInstance().pushNotificationDelegate = self.bridge
        WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions, notificationDelegate: self.bridge)
        FirebaseApp.initialize()
        if #available(iOS 10.0, *) {
            
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
          
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Handling universal links
    override func application(_ application: UIApplication,
                              continue userActivity: NSUserActivity,
                              restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        if let webPageUrl = userActivity.webpageURL{
            WebEngage.sharedInstance().deeplinkManager.getAndTrackDeeplink(webPageUrl) { location in
                self.bridge?.trackDeeplinkURLCallback(location)
            }
        }
        return true
    }
}


extension AppDelegate {

    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print("center: ", center, "\nnotification: ", notification)

        WEGManualIntegration.userNotificationCenter(center, willPresent: notification)

        completionHandler([.alert, .badge, .sound])
    }

    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        print("center: ", center, " response: ", response)

        WEGManualIntegration.userNotificationCenter(center, didReceive: response)

        completionHandler()
    }
}

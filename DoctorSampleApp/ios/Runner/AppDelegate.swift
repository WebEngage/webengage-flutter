import UIKit
import Flutter
import WebEngage
import webengage_flutter
import FirebaseCore
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      var bridge = WebEngagePlugin()
      
      FirebaseApp.configure()
      WebEngage.sharedInstance().pushNotificationDelegate = bridge.self
      WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension AppDelegate {

    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print("center: ", center, "\nnotification: ", notification)
        
        WEGManualIntegration.userNotificationCenter(center, willPresent: notification)

        completionHandler([.badge, .sound])
    }

    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        print("center: ", center, " response: ", response)
        
        WEGManualIntegration.userNotificationCenter(center, didReceive: response)

        completionHandler()
    }

    @available(iOS 12.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {

        print("center: ", center, "\n openSettingsForNotification: ", notification ?? "nil object")
    }
}

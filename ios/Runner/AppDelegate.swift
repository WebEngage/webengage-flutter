import UIKit
import Flutter
import WebEngage
import webengage_flutter
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    var bridge: WebEngagePlugin? = nil

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      bridge = WebEngagePlugin()
      WebEngage.sharedInstance().pushNotificationDelegate = bridge.self
      GeneratedPluginRegistrant.register(with: self)
      WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions, notificationDelegate: bridge.self)
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self
      }
    return true
  }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool{
        if userActivity.webpageURL != nil {
            WebEngage.sharedInstance().deeplinkManager.getAndTrackDeeplink(userActivity.webpageURL!, callbackBlock: { [self] location in
                //send location to react
                  if self.bridge == nil {
                      self.bridge = WebEngagePlugin()
                }
                  self.bridge!.trackDeeplinkURLCallback(location)
            })
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

        completionHandler([.badge, .sound, .alert])
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

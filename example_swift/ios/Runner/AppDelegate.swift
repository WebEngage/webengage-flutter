import UIKit
import Flutter
import WebEngage
import webengage_flutter

@UIApplicationMain
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

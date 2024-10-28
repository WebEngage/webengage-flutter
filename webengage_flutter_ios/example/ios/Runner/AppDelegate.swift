import Flutter
import UIKit
import WebEngage
import webengage_flutter_ios

@main
@objc class AppDelegate: FlutterAppDelegate {
 var bridge:WebEngagePlugin? = nil
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    bridge = WebEngagePlugin()
              // Push notification delegates
            WebEngage.sharedInstance().pushNotificationDelegate = self.bridge
            WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions, notificationDelegate: self.bridge)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


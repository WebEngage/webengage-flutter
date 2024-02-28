import UIKit
import Flutter
import WebEngage
import webengage_flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      var bridge = WebEngagePlugin()
      WebEngage.sharedInstance().pushNotificationDelegate = bridge.self
      WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

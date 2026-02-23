import Flutter
import UIKit
import WebEngage

/// Main application delegate for the Flutter iOS app.
/// Handles WebEngage SDK initialization and method channel communication.
@main
@objc class AppDelegate: FlutterAppDelegate,FlutterImplicitEngineDelegate {

  /// Method channel name for Flutter-iOS communication.
  private let F_CHANNEL = "flutter_method_channel"
  
  /// Method channel instance for handling Flutter calls.
  private var methodChannel: FlutterMethodChannel?
  
  /// Launch options passed during app startup.
  private var launchOption : [UIApplication.LaunchOptionsKey: Any]?
  
  /// Flag to prevent duplicate WebEngage initialization.
  private var isWebEngageAlreadyInit = false

  /// Called when the application finishes launching.
  /// Initializes WebEngage SDK and registers Flutter plugins.
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      self.launchOption = launchOptions
      initWebEngage()
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  /// Called when Flutter engine is initialized implicitly.
  /// Sets up the method channel for Flutter-iOS communication.
  func didInitializeImplicitFlutterEngine(_ engineBridge: any FlutterImplicitEngineBridge) {
      self.setupMethodChannel(engineBridge)
  }

  /// Sets up method channel and registers handlers for Flutter method calls.
  /// Handles 'initWebEngage' and 'clearData' methods.
  private func setupMethodChannel(_ engineBridge: any FlutterImplicitEngineBridge) {



    methodChannel = FlutterMethodChannel(
      name: F_CHANNEL,
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )

    methodChannel?.setMethodCallHandler { [weak self] call, result in

      guard let self = self else {
        result(FlutterError(
          code: "DEALLOCATED",
          message: "AppDelegate deallocated",
          details: nil))
        return
      }

      switch call.method {

      case "initWebEngage":
        self.handleInit(call: call, result: result)

      case "clearData":
        self.handleClear(result: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}


// MARK: - Handlers
private extension AppDelegate {

    /// Handles WebEngage initialization request from Flutter.
    /// Validates parameters, stores configuration, and initializes SDK.
    func handleInit(call: FlutterMethodCall, result: FlutterResult) {
        
        guard let args = call.arguments as? [String: Any],
              let licenseCode = args["licenseCode"] as? String,
              let env = args["env"] as? String,
              !licenseCode.isEmpty,
              !env.isEmpty else {
            
            result(FlutterError(
                code: "INVALID_ARGS",
                message: "licenseCode or env is missing",
                details: nil
            ))
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(licenseCode, forKey: "LICENSE_CODE")
        defaults.set(env, forKey: "ENV")
        
        DispatchQueue.main.async {
            self.initWebEngage()
        }
        
        result(true)
    }

  /// Handles data clearing request from Flutter.
  /// Removes stored license code and environment from UserDefaults.
  func handleClear(result: FlutterResult) {

    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "LICENSE_CODE")
    defaults.removeObject(forKey: "ENV")
      
    result(true)
  }
    
  /// Initializes WebEngage SDK with stored configuration.
  /// Retrieves license code and environment from UserDefaults.
  /// Prevents duplicate initialization.
  func initWebEngage(){
      if(self.isWebEngageAlreadyInit){
          return
      }
      let defaults = UserDefaults.standard
      
      guard let licenseCode = defaults.string(forKey: "LICENSE_CODE"),
            let env = defaults.string(forKey: "ENV") else {
        print("WebEngage Missing LC or ENV")
        return
      }
      
  
      let environment = WEGEnvironment.from(env)
      
      let config = WebEngageConfig.builder()
          .setEnvironment(environment)
          .setLicenseCode(licenseCode)
          .setDebugMode(true)
          .build()
      self.isWebEngageAlreadyInit = true
      WebEngage.sharedInstance().application(UIApplication.shared, didFinishLaunchingWithOptions: self.launchOption, webengageConfig: config)
      
  }

}

/// Extension to map string values to WEGEnvironment enum.
extension WEGEnvironment {

    /// Converts environment string to WEGEnvironment enum.
    /// Supported values: "US", "IN", "KSA"
    static func from(_ value: String?) -> WEGEnvironment {
        guard let value = value?.uppercased() else {
            return .none
        }

        switch value {
        case "US":
            return .US
        case "IN":
            return .IN
        case "KSA":
            return .KSA
        default:
            return .none
        }
    }
}

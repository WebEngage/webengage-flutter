import Flutter
import UIKit
import XCTest

// This demonstrates a simple unit test of the iOS portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class RunnerTests: XCTestCase {

  func testPluginRegistration() {
    // Verify the plugin can be registered without crashing
    let registrar = MockFlutterPluginRegistrar()
    WebEngagePlugin.register(with: registrar)
    XCTAssertTrue(registrar.didRegister)
  }
}

class MockFlutterPluginRegistrar: NSObject, FlutterPluginRegistrar {
  var didRegister = false

  func messenger() -> FlutterBinaryMessenger {
    return MockBinaryMessenger()
  }

  func textures() -> FlutterTextureRegistry {
    fatalError("Not implemented")
  }

  func register(_ factory: FlutterPlatformViewFactory, withId factoryId: String) {}
  func register(_ factory: FlutterPlatformViewFactory, withId factoryId: String, gestureRecognizersBlockingPolicy: FlutterPlatformViewGestureRecognizersBlockingPolicy) {}

  func publish(_ value: NSObject) {}

  func addMethodCallDelegate(_ delegate: FlutterPlugin, channel: FlutterMethodChannel) {
    didRegister = true
  }

  func addApplicationDelegate(_ delegate: FlutterPlugin) {}

  func lookupKey(forAsset asset: String) -> String { return asset }
  func lookupKey(forAsset asset: String, fromPackage package: String) -> String { return asset }
}

class MockBinaryMessenger: NSObject, FlutterBinaryMessenger {
  func send(onChannel channel: String, message: Data?) {}
  func send(onChannel channel: String, message: Data?, binaryReply callback: FlutterBinaryReply?) {}
  func setMessageHandlerOnChannel(_ channel: String, binaryMessageHandler handler: FlutterBinaryMessageHandler?) -> FlutterBinaryMessengerConnection {
    return FlutterBinaryMessengerConnection(0)
  }
  func cleanUpConnection(_ connection: FlutterBinaryMessengerConnection) {}
}

import Flutter
import UIKit

public class SwiftMiniaudioDecoderPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "miniaudio_decoder", binaryMessenger: registrar.messenger())
    let instance = SwiftMiniaudioDecoderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

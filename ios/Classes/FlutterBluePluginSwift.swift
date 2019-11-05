import Flutter
import UIKit

public class FlutterBluePluginSwift: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: NAMESPACE + "/swift", binaryMessenger: registrar.messenger())
    let instance = FlutterBluePluginSwift()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
       if (call.method == "getPlatformVersion") {
          result("iOS " + UIDevice.current.systemVersion)
       }
       else if(call.method == "updateFirmware") {
       
        guard let args = call.arguments else {
          return
        }
        if let myArgs = args as? [String: Any],
           let remoteId = myArgs["deviceId"] as? String,
           let firmware = myArgs["firmware"] as? String {
          result("Params received on iOS = \(remoteId), \(firmware)")
        } else {
          result("iOS could not extract flutter arguments in method: (sendParams)")
        }
        result("Error")
      }
  }
}

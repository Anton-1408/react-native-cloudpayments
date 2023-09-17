import Foundation;

@objc(ThreeDSecure)
class ThreeDSecureManager: NSObject {
  @objc var bridge: RCTBridge!

  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;

  @objc
  public func request(_ parametres3DS: Dictionary<String, String>, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    do {
      ThreeDSecureManager.resolve = resolve;
      ThreeDSecureManager.reject = reject;
      
      let parametres3DSFromDictionaryToJSON = try JSONSerialization.data(withJSONObject: parametres3DS, options: .prettyPrinted)
      let requestData = try JSONDecoder().decode(Parametres3DS.self, from: parametres3DSFromDictionaryToJSON)
      
      
      let threeDSecureController = ThreeDSecureController();

      threeDSecureController.onShow();
      threeDSecureController.onRequest(
        transactionId: requestData.transactionId,
        paReq: requestData.paReq,
        acsUrl: requestData.acsUrl
      );
    } catch {
      print("request", error)
    }
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc
  func methodQueue() -> DispatchQueue {
    return .main
  }
}

import Foundation;

@objc(ThreeDSecure)
class ThreeDSecure: NSObject {
  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;

  @objc
  public func requestThreeDSecure(_ parametres3DS: Dictionary<String, String>, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    let transactionId = parametres3DS["transactionId"]!;
    let paReq = parametres3DS["paReq"]!;
    let acsUrl = parametres3DS["acsUrl"]!;

    ThreeDSecure.resolve = resolve;
    ThreeDSecure.reject = reject;

    DispatchQueue.main.async {
      let threeDSecure = ThreeDSecureController();

      threeDSecure.onShowController();
      threeDSecure.onRequest(transactionId: transactionId, paReq: paReq, acsUrl: acsUrl);
    }
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

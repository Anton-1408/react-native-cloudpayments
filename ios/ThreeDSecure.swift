import Foundation;

@objc(ThreeDSecure)
class ThreeDSecure: NSObject {
  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;

  @objc
  public func requestThreeDSecure(_ parametres3DS: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    let transactionId = parametres3DS.value(forKey: "transactionId") as! String;
    let paReq = parametres3DS.value(forKey: "paReq") as! String;
    let acsUrl = parametres3DS.value(forKey: "acsUrl") as! String;

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

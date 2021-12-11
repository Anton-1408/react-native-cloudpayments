import Foundation;

@objc(ThreeDSecure)
class ThreeDSecure: RCTViewManager {
  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;
  private let threeDSecure = ThreeDSecureController();

  @objc
  public func requestThreeDSecure(_ parametres3DS: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    let transactionId = parametres3DS.value(forKey: "transactionId") as! String;
    let paReq = parametres3DS.value(forKey: "paReq") as! String;
    let acsUrl = parametres3DS.value(forKey: "acsUrl") as! String;

    ThreeDSecure.resolve = resolve;
    ThreeDSecure.reject = reject;

    threeDSecure.open(transactionId: transactionId, paReq: paReq, acsUrl: acsUrl);
  }

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

import Foundation;

@objc(ThreeDSecure)
class ThreeDSecure: NSObject {
  @objc var bridge: RCTBridge!

  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;

  @objc
  public func requestThreeDSecure(_ parametres3DS: Dictionary<String, String>, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    let requestData = PARAMETRES_3DS(parametres3DS: parametres3DS);

    ThreeDSecure.resolve = resolve;
    ThreeDSecure.reject = reject;

    let threeDSecure = ThreeDSecureController();

    threeDSecure.onShowController();
    threeDSecure.onRequest(
      transactionId: requestData.transactionId,
      paReq: requestData.paReq,
      acsUrl: requestData.acsUrl
    );
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

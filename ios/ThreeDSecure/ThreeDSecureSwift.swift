import Foundation;
import React

@objc(ThreeDSecureSwift)
public class ThreeDSecureSwift: NSObject {
  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;

  @objc
  public static let shared = ThreeDSecureSwift()

  @objc
  private override init() {
    super.init()
  }

  @objc
  public func request(_ parametres3DS: Dictionary<String, String>, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    let requestData = Parametres3DS.init(parametres3DS: parametres3DS)

    ThreeDSecureSwift.resolve = resolve;
    ThreeDSecureSwift.reject = reject;
    
    RCTExecuteOnMainQueue {
      let threeDSecure = ThreeDSecureController();

      threeDSecure.onShowController();
      threeDSecure.onRequest(
        transactionId: requestData.transactionId,
        paReq: requestData.paReq,
        acsUrl: requestData.acsUrl
      );
    }
  }
}

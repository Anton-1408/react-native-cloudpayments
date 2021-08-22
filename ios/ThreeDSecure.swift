import Foundation;
import UIKit;

@objc(ThreeDSecure)
class ThreeDSecure: UIViewController {
  private let d3ds: D3DS = D3DS.init();
  private var resolve: RCTPromiseResolveBlock?;
  private var reject: RCTPromiseRejectBlock?;
  private var window = UIWindow(frame: UIScreen.main.bounds);

  @objc
  public func requestThreeDSecure(_ parametres3DS: NSDictionary, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    let transactionId = parametres3DS.value(forKey: "transactionId") as! String;
    let paReq = parametres3DS.value(forKey: "paReq") as! String;
    let acsUrl = parametres3DS.value(forKey: "acsUrl") as! String;

    self.resolve = resolve;
    self.reject = reject;

    DispatchQueue.main.async {
        self.window.rootViewController = UIViewController();
        self.window.clipsToBounds = true;
        self.window.makeKeyAndVisible();
        self.window.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width + 20, height: UIScreen.main.bounds.height + 20);
        self.window.rootViewController?.present(self, animated: true, completion: nil);

        self.d3ds.make3DSPayment(with: self, andAcsURLString: acsUrl, andPaReqString: paReq, andTransactionIdString: transactionId)

    }
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

extension ThreeDSecure: D3DSDelegate, WKUIDelegate {
  func authorizationCompleted(withMD md: String!, andPares paRes: String!) {
    let result: NSMutableDictionary = [:];
    result["TransactionId"] = md;
    result["PaRes"] = paRes;

    self.resolve?(result);
    self.window.isHidden = true;
  }

  func authorizationFailed(withHtml html: String!) {
    self.reject?("error", html, nil);
    self.window.isHidden = true;
  }
}

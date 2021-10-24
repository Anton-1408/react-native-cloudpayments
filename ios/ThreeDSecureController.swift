import Foundation
import UIKit;

@objc(ThreeDSecureController)
class ThreeDSecureController: UIViewController {
  private let d3ds: D3DS = D3DS.init();
  private var window = UIApplication.shared.windows[0];

  public func open(transactionId: String, paReq: String, acsUrl: String) {
    DispatchQueue.main.async {
      self.window.rootViewController?.present(self, animated: true, completion: nil);
      self.d3ds.make3DSPayment(with: self, andAcsURLString: acsUrl, andPaReqString: paReq, andTransactionIdString: transactionId)

    }
  }
}

extension ThreeDSecureController: D3DSDelegate, WKUIDelegate {
  func authorizationCompleted(withMD md: String!, andPares paRes: String!) {
    let result: NSMutableDictionary = [:];
    result["TransactionId"] = md;
    result["PaRes"] = paRes;

    self.window.rootViewController?.dismiss(animated: true, completion: nil);
    ThreeDSecure.resolve?(result);
  }

  func authorizationFailed(withHtml html: String!) {
    self.window.rootViewController?.dismiss(animated: true, completion: nil);
    ThreeDSecure.reject?("error", html, nil);
  }
}

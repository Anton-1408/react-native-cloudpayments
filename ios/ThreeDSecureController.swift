import Foundation
import UIKit;

@objc(ThreeDSecureController)
class ThreeDSecureController: UIViewController {
  private let d3ds: D3DS = D3DS.init();

  public func open(transactionId: String, paReq: String, acsUrl: String) {
    guard let rootViewController = RCTPresentedViewController() else {
      return
    }

    DispatchQueue.main.async {
      rootViewController.present(self, animated: true, completion: nil);

      self.d3ds.make3DSPayment(with: self, andAcsURLString: acsUrl, andPaReqString: paReq, andTransactionIdString: transactionId)

    }
  }
}

extension ThreeDSecureController: D3DSDelegate, WKUIDelegate {
  func authorizationCompleted(withMD md: String!, andPares paRes: String!) {
    guard let rootViewController = RCTPresentedViewController() else {
      return
    }

    guard let resolve = ThreeDSecure.resolve else {
        return
    };

    let result: NSMutableDictionary = [:];
    result["TransactionId"] = md;
    result["PaRes"] = paRes;

    rootViewController.dismiss(animated: true, completion: nil);
    resolve(result);
  }

  func authorizationFailed(withHtml html: String!) {
    guard let rootViewController = RCTPresentedViewController() else {
      return
    }

    guard let reject = ThreeDSecure.reject else {
      return
    };

    rootViewController.dismiss(animated: true, completion: nil);
    reject("error", html, nil);
  }
}

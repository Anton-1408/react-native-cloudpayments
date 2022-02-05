import Foundation
import PassKit
import Cloudpayments
import UIKit
import WebKit

class ThreeDSecureController: UIViewController {
  let threeDsProcessor = ThreeDsProcessor();

  public func onRequest(transactionId: String, paReq: String, acsUrl: String) {
    let data = ThreeDsData.init(transactionId: transactionId, paReq: paReq, acsUrl: acsUrl);

    threeDsProcessor.make3DSPayment(with: data, delegate: self);
  }

  public func onShowController() {
    DispatchQueue.main.async {
      guard let rootViewController = RCTPresentedViewController() else {
        return
      }

      rootViewController.present(self, animated: true, completion: nil);
      self.view.backgroundColor = .white;
    }
  }

  private func hideController() {
    DispatchQueue.main.async {
      guard let rootViewController = RCTPresentedViewController() else {
        return
      }

      rootViewController.dismiss(animated: true, completion: nil)
    }
  }
}

extension ThreeDSecureController: ThreeDsDelegate {
  func willPresentWebView(_ webView: WKWebView) {
    webView.frame = self.view.bounds
    webView.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(webView)

    NSLayoutConstraint.activate([
      webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      webView.topAnchor.constraint(equalTo: self.view.topAnchor),
      webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }

  func onAuthorizationCompleted(with md: String, paRes: String) {
    self.hideController()

    guard let resolve = ThreeDSecure.resolve else {
        return
    };

    let result: NSMutableDictionary = [:];

    result["TransactionId"] = md;
    result["PaRes"] = paRes;

    resolve(result);
  }

  func onAuthorizationFailed(with html: String) {
    self.hideController()

    guard let reject = ThreeDSecure.reject else {
      return
    };

    reject("error", html, nil);
  }
}

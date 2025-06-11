import Foundation
import PassKit
import UIKit
import WebKit
import React
import Cloudpayments

class ThreeDSecureController: UIViewController {
  let threeDsProcessor = ThreeDsProcessor();

  public func onRequest(transactionId: String, paReq: String, acsUrl: String) {
    let data = ThreeDsData.init(transactionId: transactionId, paReq: paReq, acsUrl: acsUrl);

    // запускаем контроллер с подтверждением оплаты
    threeDsProcessor.make3DSPayment(with: data, delegate: self);
  }

  public func onShowController() {
    guard let rootViewController = RCTPresentedViewController() else {
      return
    }

    // запускаем контроллер из главного
    rootViewController.present(self, animated: true, completion: nil);

    self.view.backgroundColor = .white;
  }

  private func hideController() {
    guard let rootViewController = RCTPresentedViewController() else {
      return
    }

    rootViewController.dismiss(animated: true, completion: nil)
  }
}

extension ThreeDSecureController: ThreeDsDelegate {
  func willPresentWebView(_ webView: WKWebView) {
    // располагаем webview в view текущего контроллера
    webView.frame = self.view.bounds
    // запретить автоматическое изменение размпера
    webView.translatesAutoresizingMaskIntoConstraints = false

    // запускаем webView
    self.view.addSubview(webView)

    // растягиваем контейнер на весь контроллер
    NSLayoutConstraint.activate([
      webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      webView.topAnchor.constraint(equalTo: self.view.topAnchor),
      webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }

  func onAuthorizationCompleted(with md: String, paRes: String) {
    self.hideController()

    guard let resolve = ThreeDSecureSwift.resolve else {
        return
    };

    var result: Dictionary<String, String> = [:];

    result["TransactionId"] = md;
    result["PaRes"] = paRes;

    resolve(result)
  }

  func onAuthorizationFailed(with html: String) {
    self.hideController()
    
    guard let reject = ThreeDSecureSwift.reject else {
      return
    };
    
    reject("error", html, nil)
  }
}

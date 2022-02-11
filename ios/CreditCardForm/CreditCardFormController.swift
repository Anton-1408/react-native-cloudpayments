import Foundation;
import UIKit;
import Cloudpayments;
import AVFoundation;

class CardFormController: UIViewController {
  var configuration: PaymentConfiguration!;
  var scannerCompletion: ((String?, UInt?, UInt?, String?) -> Void)?;

  convenience init(paymentData: PaymentData, configuration: Dictionary<String, Bool>) {
    self.init();

    let useDualMessagePayment = configuration["useDualMessagePayment"]!;
    let disableApplePay = configuration["disableApplePay"]!;

    self.configuration = PaymentConfiguration.init(
      paymentData: paymentData,
      delegate: self,
      uiDelegate: nil,
      scanner: self,
      useDualMessagePayment: useDualMessagePayment,
      disableApplePay: disableApplePay
    );
  }

  func showCreditCardForm() -> Void {
    DispatchQueue.main.async {
      guard let rootViewController = RCTPresentedViewController() else {
        return
      };

      rootViewController.addChild(self);
      PaymentForm.present(with: self.configuration, from: rootViewController);
    }
  }
};

extension CardFormController: PaymentDelegate {
  func onPaymentFinished(_ transactionId: Int?) {
    guard let resolve = CreditCardFormManager.resolve else {
      return
    };

    resolve(transactionId);
  }

  func onPaymentFailed(_ errorMessage: String?) {
    guard let reject = CreditCardFormManager.reject else {
      return
    };

    reject("error", errorMessage, nil);
  }
};

extension CardFormController: PaymentCardScanner {
  func startScanner(completion: @escaping (String?, UInt?, UInt?, String?) -> Void) -> UIViewController? {
    self.scannerCompletion = completion;
    let scanController = CardIOPaymentViewController.init(paymentDelegate: self)
    return scanController
  }
}

extension CardFormController: CardIOPaymentViewControllerDelegate {
  func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
    paymentViewController.dismiss(animated: true, completion: nil)
  }

  func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
    self.scannerCompletion?(cardInfo.cardNumber, cardInfo.expiryMonth, cardInfo.expiryYear, cardInfo.cvv)
    paymentViewController.dismiss(animated: true, completion: nil)
  }
}

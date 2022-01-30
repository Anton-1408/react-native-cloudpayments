import UIKit;
import Cloudpayments;

class CardFormController: UIViewController {
  var configuration: PaymentConfiguration!;

  convenience init(paymentData: PaymentData, configuration: Dictionary<String, Bool>) {
    self.init();

    let useDualMessagePayment = configuration["useDualMessagePayment"]!;
    let disableApplePay = configuration["disableApplePay"]!;

    self.configuration = PaymentConfiguration.init(
      paymentData: paymentData,
      delegate: self,
      uiDelegate: nil,
      scanner: nil,
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

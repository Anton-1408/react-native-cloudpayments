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
        uiDelegate: self,
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

      rootViewController.present(self, animated: true, completion: nil)
      PaymentForm.present(with: self.configuration, from: self);
    }
  }

  private func hideController() -> Void {
    DispatchQueue.main.async {
      guard let rootViewController = RCTPresentedViewController() else {
        return
      }

      rootViewController.dismiss(animated: true, completion: nil)
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

extension CardFormController: PaymentUIDelegate {
  func paymentFormWillDisplay() {}

  func paymentFormDidDisplay() {}

  func paymentFormWillHide() {}

  func paymentFormDidHide() {
    self.hideController();
  }
};

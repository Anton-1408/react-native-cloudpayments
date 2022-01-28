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

      PaymentForm.present(with: self.configuration, from: rootViewController);
    }
  }
};

extension CardFormController: PaymentDelegate {
  func onPaymentFinished(_ transactionId: Int?) {
    
  }
    
  func onPaymentFailed(_ errorMessage: String?) {
     
  }
};

extension CardFormController: PaymentUIDelegate {
  func paymentFormWillDisplay() {
 
  }
    
  func paymentFormDidDisplay() {
 
  }
    
  func paymentFormWillHide() {

  }
    
  func paymentFormDidHide() {

  }
};

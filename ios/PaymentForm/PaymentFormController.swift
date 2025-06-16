import Foundation
import Cloudpayments
import React

public class PaymentFormController: UIViewController {
  private var configuration: PaymentConfiguration?;
  private var scannerCompletion: ((String?, UInt?, UInt?, String?) -> Void)?;
  
  convenience init(paymentData: PaymentData, configurationData: Dictionary<String, Any>) {
    self.init();
    
    let paymentDataParsed = ConfigurationPaymentForm(data: configurationData)
    
    configuration = PaymentConfiguration.init(
      publicId: paymentDataParsed.publicId,
      paymentData: paymentData,
      delegate: self,
//      uiDelegate: self,
      scanner: self,
      requireEmail: paymentDataParsed.requireEmail,
      useDualMessagePayment: paymentDataParsed.useDualMessagePayment,
      disableApplePay: paymentDataParsed.disableApplePay
    )
  }
  
  public func onOpen() -> Void {
    guard let rootViewController = RCTPresentedViewController() else {
      return
    };

    //Добавляем контроллер в качестве дочернего элемента текущего контроллера .
    rootViewController.addChild(self);

//    PaymentForm.present(with: self.configuration, from: rootViewController);
  }
  
}


extension PaymentFormController: PaymentDelegate {
  public func onPaymentFailed(_ errorMessage: String?) {
    guard let reject = PaymentFormSwift.reject else {
      return
    };

    reject("error", errorMessage, nil);

  }
  
  public func onPaymentFinished(_ transactionId: Int64?) {
    guard let resolve = PaymentFormSwift.resolve else {
      return
    };

    resolve(transactionId);
  }
};

extension PaymentFormController: PaymentCardScanner {
  public func startScanner(completion: @escaping (String?, UInt?, UInt?, String?) -> Void) -> UIViewController? {
    self.scannerCompletion = completion;
    
    let scanController = CardIOPaymentViewController.init(paymentDelegate: self)
    
    return scanController
  }
}

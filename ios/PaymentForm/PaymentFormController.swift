//
//  PaymentFormManager.swift
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 17.09.2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation;
import UIKit;
import Cloudpayments;
import AVFoundation;

class PaymentFormController: UIViewController {
  var configuration: PaymentConfiguration!;
  var scannerCompletion: ((String?, UInt?, UInt?, String?) -> Void)?;

  // создаем дополнительный конструктор
  convenience init(paymentData: PaymentData, configuration: ConfigurationPaymentForm, publicId: String) {
    self.init();

    self.configuration = PaymentConfiguration.init(
      publicId: publicId,
      paymentData: paymentData,
      delegate: self,
      uiDelegate: nil,
      scanner: self,
      useDualMessagePayment: configuration.useDualMessagePayment,
      disableApplePay: configuration.disableApplePay,
      disableYandexPay: configuration.disableYandexPay,
      changedEmail: nil
    );
  }

  func onShow() -> Void {
    guard let rootViewController = RCTPresentedViewController() else {
      return
    };

    //Добавляем контроллер в качестве дочернего элемента текущего контроллера .
    rootViewController.addChild(self);

    PaymentForm.present(with: self.configuration, from: rootViewController);
  }
};

extension PaymentFormController: PaymentDelegate {
  func onPaymentFinished(_ transactionId: Int?) {
    guard let resolve = PaymentFormManager.resolve else {
      return
    };

    resolve(transactionId);
  }

  func onPaymentFailed(_ errorMessage: String?) {
    guard let reject = PaymentFormManager.reject else {
      return
    };

    reject("error", errorMessage, nil);
  }
};

extension PaymentFormController: PaymentCardScanner {
  func startScanner(completion: @escaping (String?, UInt?, UInt?, String?) -> Void) -> UIViewController? {
    self.scannerCompletion = completion;
    
    let scanController = CardIOPaymentViewController.init(paymentDelegate: self)
    
    return scanController
  }
}

extension PaymentFormController: CardIOPaymentViewControllerDelegate {
  func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
    paymentViewController.dismiss(animated: true, completion: nil)
  }

  func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
    self.scannerCompletion?(cardInfo.cardNumber, cardInfo.expiryMonth, cardInfo.expiryYear, cardInfo.cvv)
    
    paymentViewController.dismiss(animated: true, completion: nil)
  }
}

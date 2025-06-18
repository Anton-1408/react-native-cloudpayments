import Foundation
import Cloudpayments
import React

public class PaymentFormController: UIViewController {
  private var configuration: PaymentConfiguration?;
  private var scannerCompletion: ((String?, UInt?, UInt?, String?) -> Void)?;
  private var currentMode = "SelectPaymentMethod"
  
  private lazy var tPayView = PaymentTPayView()
  private lazy var sbpView = PaymentSbpView()
  private lazy var sberPayView = PaymentSberPayView()
  
  convenience init(paymentData: PaymentData, configurationData: Dictionary<String, Any>) {
    self.init();
    
    let paymentDataParsed = ConfigurationPaymentForm(data: configurationData)
    
    configuration = PaymentConfiguration.init(
      publicId: paymentDataParsed.publicId,
      paymentData: paymentData,
      delegate: self,
      uiDelegate: nil,
      scanner: nil,
      requireEmail: paymentDataParsed.requireEmail,
      useDualMessagePayment: paymentDataParsed.useDualMessagePayment,
      disableApplePay: true
    )
    
    tPayView.configuration = configuration
    sbpView.configuration = configuration
    sberPayView.configuration = configuration
    
    currentMode = paymentDataParsed.mode
  }
  
  public func onOpen() -> Void {
    guard let rootViewController = RCTPresentedViewController() else {
      return
    };
    
    switch(currentMode){
      case "TPay":
        openTBankPay(rootViewController: rootViewController)
        break;
      case "SberPay":
        openSberPay(rootViewController: rootViewController)
        break;
      case "SBP":
        openSBP(rootViewController: rootViewController)
        break;
      default:
        openSelectPaymentMethod(rootViewController: rootViewController)
        break
    }
  }
  
  private func openTBankPay(rootViewController: UIViewController) {
    let label = UILabel()
    
    label.text = "TPay"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 26)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    self.view.backgroundColor = .white
    
    tPayView.addSubview(label)
    self.view.addSubview(tPayView)
    
    
    tPayView.backgroundColor = .black
    tPayView.layer.cornerRadius = 8

    tPayView.translatesAutoresizingMaskIntoConstraints = false
    tPayView.isHidden = false
    tPayView.delegate = self
  
    
    NSLayoutConstraint.activate([
      tPayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      tPayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      tPayView.heightAnchor.constraint(equalToConstant: 50),
      tPayView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      label.centerXAnchor.constraint(equalTo: tPayView.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: tPayView.centerYAnchor)
    ])
    
    rootViewController.present(self, animated: true, completion: nil)
  }
  
  private func openSelectPaymentMethod(rootViewController: UIViewController) {
    guard let configuration = self.configuration else {
      return
    }
    
    rootViewController.addChild(self)
    
    PaymentForm.present(with: configuration, from: rootViewController);
  }
  
  private func openSberPay(rootViewController: UIViewController) {
    let label = UILabel()
    
    label.text = "SberPay"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 26)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    self.view.backgroundColor = .white
    
    sberPayView.addSubview(label)
    self.view.addSubview(sberPayView)
    
    
    sberPayView.backgroundColor = .black
    sberPayView.layer.cornerRadius = 8

    sberPayView.translatesAutoresizingMaskIntoConstraints = false
    sberPayView.isHidden = false
    sberPayView.delegate = self
  
    
    NSLayoutConstraint.activate([
      sberPayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      sberPayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      sberPayView.heightAnchor.constraint(equalToConstant: 50),
      sberPayView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      label.centerXAnchor.constraint(equalTo: sberPayView.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: sberPayView.centerYAnchor)
    ])
    
    rootViewController.present(self, animated: true, completion: nil)
  }
  
  private func openSBP(rootViewController: UIViewController) {
    let label = UILabel()
    
    label.text = "СБП"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 26)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    self.view.backgroundColor = .white
    
    sbpView.addSubview(label)
    self.view.addSubview(sbpView)
    
    
    sbpView.backgroundColor = .black
    sbpView.layer.cornerRadius = 8

    sbpView.translatesAutoresizingMaskIntoConstraints = false
    sbpView.isHidden = false
    sbpView.delegate = self
  
    
    NSLayoutConstraint.activate([
      sbpView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      sbpView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      sbpView.heightAnchor.constraint(equalToConstant: 50),
      sbpView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      label.centerXAnchor.constraint(equalTo: sbpView.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: sbpView.centerYAnchor)
    ])
    
    rootViewController.present(self, animated: true, completion: nil)
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

extension PaymentFormController: PaymentTPayDelegate {
  public func resultPayment(_ tPay: Cloudpayments.PaymentTPayView, result: Cloudpayments.PaymentTPayView.PaymentAction, error: String?, transactionId: Int64?) {
    guard let resolve = PaymentFormSwift.resolve else {
      return
    };

    resolve(transactionId);
  }
}

extension PaymentFormController: PaymentSbpDelegate {
  public func resultPayment(_ sbp: Cloudpayments.PaymentSbpView, result: Cloudpayments.PaymentSbpView.PaymentAction, error: String?, transactionId: Int64?) {
    guard let resolve = PaymentFormSwift.resolve else {
      return
    };

    resolve(transactionId);
  }
}

extension PaymentFormController: PaymentSberPayDelegate {
  public func resultPayment(_ sberPay: Cloudpayments.PaymentSberPayView, result: Cloudpayments.PaymentSberPayView.PaymentAction, error: String?, transactionId: Int64?) {
    guard let resolve = PaymentFormSwift.resolve else {
      return
    };

    resolve(transactionId);
  }
}

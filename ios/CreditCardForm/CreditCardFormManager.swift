import Foundation
import Cloudpayments;

@objc(CreditCardFormManager)
class CreditCardFormManager: NSObject {
  var paymentData: PaymentData?;

  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;

  @objc
  func initialPaymentData (_ paymentData: Dictionary<String, String>, jsonData: Dictionary<String, String>?) -> Void {
    let initialData = PAYMENT_DATA(paymentData: paymentData, jsonData: jsonData);

    self.paymentData = PaymentData.init(publicId: initialData.publicId)
      .setAccountId(initialData.accountId)
      .setDescription(initialData.description)
      .setApplePayMerchantId(initialData.applePayMerchantId)
      .setIpAddress(initialData.ipAddress)
      .setInvoiceId(initialData.invoiceId)
      .setCardholderName(initialData.cardholderName)
      .setJsonData(initialData.jsonData!)
  }

  @objc
  func setTotalAmount(_ totalAmount: String, currency: String) -> Void {
    let currencyValue = Currency.init(rawValue: currency)!;

    guard let _ = self.paymentData?
            .setCurrency(currencyValue)
            .setAmount(totalAmount)
    else {
        return
    };
  }

  @objc
  func showCreditCardForm(_ configuration: Dictionary<String, Bool>, resolve:  @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    CreditCardFormManager.resolve = resolve;
    CreditCardFormManager.reject = reject;

    guard let paymentData = self.paymentData else {
      reject("error", "Error initial data", nil);
      return;
    }

    DispatchQueue.main.async {
      let cardFormController = CardFormController(paymentData: paymentData, configuration: configuration);
      cardFormController.showCreditCardForm();
    }
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

import Foundation
import Cloudpayments;

@objc(CreditCardFormManager)
class CreditCardFormManager: NSObject {
  @objc var bridge: RCTBridge!

  private var paymentData: PaymentData?;

  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;

  @objc
  func initialPaymentData (_ paymentData: Dictionary<String, String>, jsonData: Dictionary<String, String>?) -> Void {
    let initialData = PAYMENT_DATA(paymentData: paymentData, jsonData: jsonData);

    self.paymentData = PaymentData.init(publicId: initialData.publicId)
      .setAccountId(initialData.accountId)
      .setApplePayMerchantId(initialData.applePayMerchantId)
      .setIpAddress(initialData.ipAddress)
      .setCardholderName(initialData.cardholderName)
      .setJsonData(initialData.jsonData!)
      .setCultureName(initialData.cultureName)
      .setPayer(initialData.payer)
  }

  @objc
  func setDetailsOfPayment(_ details: Dictionary<String, String>) -> Void {
    let description = details["description"];
    let invoiceId = details["invoiceId"];
    let totalAmount = details["totalAmount"]!;
    let currency = details["currency"]!

    let currencyValue = Currency.init(rawValue: currency)!;

    guard let _ = self.paymentData?
            .setCurrency(currencyValue)
            .setAmount(totalAmount)
            .setDescription(description)
            .setInvoiceId(invoiceId)
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

    let cardFormController = CardFormController(paymentData: paymentData, configuration: configuration);

    cardFormController.showCreditCardForm();
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc
  func methodQueue() -> DispatchQueue {
    return .main
  }
}

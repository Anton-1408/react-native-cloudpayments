import Foundation
import Cloudpayments;

@objc(PaymentFormManager)
final class PaymentFormManager: NSObject {
  @objc var bridge: RCTBridge!

  private var paymentData: PaymentData?;
  private var publicId: String = ""

  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;

  @objc
  func initial(_ paymentData: Dictionary<String, String>) -> Void {
    do {
      let paymentDataFromDictionaryToJSON = try JSONSerialization.data(withJSONObject: paymentData, options: .prettyPrinted)

      let initialData = try JSONDecoder().decode(InitionalPaymentData.self, from: paymentDataFromDictionaryToJSON)

      let applePayMerchantId = initialData.applePayMerchantId ?? "";
      let yandexPayMerchantId = initialData.yandexPayMerchantId ?? "";
      let payer = initialData.payer != nil ? try PaymentDataPayer.init(from: initialData.payer as! Decoder) : nil;


      self.publicId = initialData.publicId
      self.paymentData = PaymentData.init()
          .setAccountId(initialData.accountId)
          .setApplePayMerchantId(applePayMerchantId)
          .setIpAddress(initialData.ipAddress)
          .setCardholderName(initialData.cardholderName)
          .setYandexPayMerchantId(yandexPayMerchantId)
          .setEmail(initialData.email)
          .setCultureName(initialData.cultureName)
          .setPayer(payer)
    } catch {
      print("initial", error)
    }
  }

  @objc
  func setDetailsOfPayment(_ details: Dictionary<String, String>) -> Void {
    do {
      let detailsFromDictionaryToJSON = try JSONSerialization.data(withJSONObject: details, options: .prettyPrinted)

      let initialData = try JSONDecoder().decode(Payment.self, from: detailsFromDictionaryToJSON)

      guard let _ = self.paymentData?
        .setCurrency(initialData.currency)
        .setAmount(initialData.amount)
        .setDescription(initialData.description)
        .setInvoiceId(initialData.invoiceId)
      else {
          return
      };
    } catch {
      print("setDetailsOfPayment", error)
    }
  }

  @objc
  func open(_ configuration: Dictionary<String, Bool>, resolve:  @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    do {
      guard let paymentData = self.paymentData else {
        reject("error", "Error initial paymentData", nil);
        return;
      }

      PaymentFormManager.resolve = resolve;
      PaymentFormManager.reject = reject;

      let configurationFromDictionaryToJSON = try JSONSerialization.data(withJSONObject: configuration, options: .prettyPrinted)
      let configurationData = try JSONDecoder().decode(ConfigurationPaymentForm.self, from: configurationFromDictionaryToJSON)


      let paymentFormController = PaymentFormController(
        paymentData: paymentData,
        configuration: configurationData,
        publicId: publicId
      );

      paymentFormController.onShow();
    } catch {
      print("open", error)
    }
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

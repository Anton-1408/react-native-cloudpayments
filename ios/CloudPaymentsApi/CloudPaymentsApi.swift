import Foundation
import CloudpaymentsNetworking;
import Cloudpayments;

@objc(CloudPaymentsApi)
class CloudPaymentsApi: NSObject {
  var api: CloudpaymentsApi?;
  var paymentData: PaymentData?;

  @objc
  func initApi(_ paymentData: Dictionary<String, String>, jsonData: Dictionary<String, String>?) -> Void {
    let initialData = PAYMENT_DATA(paymentData: paymentData, jsonData: jsonData);

    self.api = CloudpaymentsApi(publicId: initialData.publicId);

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
  func auth(_ cardCryptogramPacket: String, email: String?, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) -> Void {
    guard let reject = reject, let resolve = resolve else {
        return
    };

    guard let api = self.api, let paymentData = self.paymentData else {
        reject("Error", "error initial data", nil);
        return;
    };

    api.auth(cardCryptogramPacket: cardCryptogramPacket, email: email, paymentData: paymentData, completion: {(response, error) in
        if let response = response {
          let result = self.convertResponseToDictionaryForReactNative(response: response)
          resolve(result);
        } else if let error = error {
          print("error", error);
          reject("Error", error.localizedDescription, nil);
        }
    })
  }

  @objc
  func charge(_ cardCryptogramPacket: String, email: String?, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) -> Void {
    guard let reject = reject, let resolve = resolve else {
        return
    };

    guard let api = self.api, let paymentData = self.paymentData else {
        reject("Error", "error initial data", nil);
        return;
    };

    api.charge(cardCryptogramPacket: cardCryptogramPacket, email: email, paymentData: paymentData, completion: {(response, error) in
        if let response = response {
            let result = self.convertResponseToDictionaryForReactNative(response: response)
            resolve(result);
        } else if let error = error {
          print("error", error);
          reject("Error", error.localizedDescription, nil);
        }
    })
  }

  // конвертируем ответ с бэка в формат json для передачи в RN
  func convertResponseToDictionaryForReactNative(response: TransactionResponse) -> String {
    let jsonEncode = JSONEncoder();

    guard let jsonData = try? jsonEncode.encode(response) else {
      return "Response is empty";
    };

    let jsonString = String(data: jsonData, encoding: .utf8)

    return jsonString ?? "Response is empty";
  }
}

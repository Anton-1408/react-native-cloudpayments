import Foundation
import CloudpaymentsNetworking;
import Cloudpayments;

@objc(CloudPaymentsApi)
class CloudPaymentsApi: NSObject {
  var api: CloudpaymentsApi?;
  var paymentData: PaymentData?;

  @objc
  func initApi(_ publicId: String, paymentData: Dictionary<String, String>, jsonData: Dictionary<String, String>?) -> Void {
    self.api = CloudpaymentsApi(publicId: publicId);

    let initialData = PAYMENT_DATA(paymentData: paymentData, jsonData: jsonData);

    self.paymentData = PaymentData.init(publicId: initialData.publicId)
      .setCurrency(initialData.currency)
      .setAmount(initialData.totalAmount)
      .setAccountId(initialData.accountId)
      .setDescription(initialData.description)
      .setApplePayMerchantId(initialData.applePayMerchantId)
      .setIpAddress(initialData.ipAddress)
      .setInvoiceId(initialData.invoiceId)
      .setJsonData(initialData.jsonData!)
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

  func convertResponseToDictionaryForReactNative(response: TransactionResponse) -> String {
    let jsonEncode = JSONEncoder();

    guard let jsonData = try? jsonEncode.encode(response) else {
      return "Response is empty";
    };

    let jsonString = String(data: jsonData, encoding: .utf8)

    return jsonString ?? "Response is empty";
  }
}

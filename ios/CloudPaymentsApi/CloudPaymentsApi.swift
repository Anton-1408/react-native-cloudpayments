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
    self.paymentData = convertToPaymentData(paymentData: paymentData, jsonData: jsonData);
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

  func convertResponseToDictionaryForReactNative(response: TransactionResponse) -> Dictionary<String, Any> {
    var responseDictionary: Dictionary<String, Any> = [:]
    let model = response.model;

    responseDictionary["message"] = response.message;
    responseDictionary["success"] = response.success;

    if (model != nil) {
      responseDictionary["model"] = [
        "transactionId": model?.transactionId as Any,
        "amount": model?.amount as Any,
        "currency": model?.currency as Any,
        "currencyCode": model?.currencyCode as Any,
        "invoiceId": model?.invoiceId as Any,
        "accountId": model?.accountId as Any,
        "email": model?.email as Any,
        "description": model?.description as Any,
        "authCode": model?.authCode as Any,
        "testMode": model?.testMode as Any,
        "ipAddress": model?.ipAddress as Any,
        "ipCountry": model?.ipCountry as Any,
        "ipCity": model?.ipCity as Any,
        "ipRegion": model?.ipRegion as Any,
        "ipDistrict": model?.ipDistrict as Any,
        "ipLatitude": model?.ipLatitude as Any,
        "ipLongitude": model?.ipLongitude as Any,
        "cardFirstSix": model?.cardFirstSix as Any,
        "cardLastFour": model?.cardLastFour as Any,
        "cardExpDate": model?.cardExpDate as Any,
        "cardType": model?.cardType as Any,
        "cardTypeCode": model?.cardTypeCode as Any,
        "issuer": model?.issuer as Any,
        "issuerBankCountry": model?.issuerBankCountry as Any,
        "status": model?.status as Any,
        "statusCode": model?.statusCode as Any,
        "reason": model?.reason as Any,
        "reasonCode": model?.reasonCode as Any,
        "cardHolderMessage": model?.cardHolderMessage as Any,
        "name": model?.name as Any,
        "paReq": model?.paReq as Any,
        "acsUrl": model?.acsUrl as Any,
        "threeDsCallbackId": model?.threeDsCallbackId as Any
      ];
    }

    return responseDictionary;
  }
}

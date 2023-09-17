import Foundation
import Cloudpayments;

struct METHOD_DATA {
  var merchantId: String
  var supportedNetworks: Array<String>
  var countryCode: String
  var currencyCode: String

  init(methodData: Dictionary<String, Any>) {
    self.countryCode = methodData["countryCode"] as! String;
    self.currencyCode = methodData["currencyCode"] as! String;
    self.merchantId = methodData["merchantId"] as! String;
    self.supportedNetworks = methodData["supportedNetworks"] as! Array<String>;
  }
}

struct PARAMETRES_3DS {
  var transactionId: String
  var paReq: String
  var acsUrl: String
  init(parametres3DS: Dictionary<String, String>) {
    self.acsUrl = parametres3DS["acsUrl"]!;
    self.paReq = parametres3DS["paReq"]!;
    self.transactionId = parametres3DS["transactionId"]!;
  }
}

struct InitionalPaymentData: Decodable {
  let publicId: String
  let email: String?
  let applePayMerchantId: String?
  let yandexPayMerchantId: String?
  let cardholderName: String?
  let accountId: String?
  let ipAddress: String?
  let cultureName: String?
  let jsonData: String?
  let payer: Payer?
}

struct Payer: Decodable {
  let firstName: String
  let lastName: String
  let middleName: String
  let birth: String
  let address: String
  let street: String
  let city: String
  let country: String
  let phone: String
  let postcode: String
}

struct Payment: Decodable {
  let amount: String
  let currency: String
  let invoiceId: String?
  let description: String?
}

struct ConfigurationPaymentForm: Decodable {
  let useDualMessagePayment: Bool
  let disableApplePay: Bool
  let disableYandexPay: Bool
}

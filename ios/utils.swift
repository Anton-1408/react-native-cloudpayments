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

struct PAYMENT_DATA {
  var publicId: String
  var applePayMerchantId: String = ""
  var invoiceId: String = ""
  var accountId: String?
  var description: String?
  var ipAddress: String?
  var jsonData: [String: String]?
  var cardholderName: String?
  var cultureName: String?
  var payer: String?

  init(paymentData: Dictionary<String, String>, jsonData: Dictionary<String, String>?) {
    self.publicId = paymentData["publicId"]!;
    self.invoiceId = paymentData["invoiceId"] ?? "";
    self.applePayMerchantId = paymentData["applePayMerchantId"] ?? "";

    self.accountId = paymentData["accountId"] ?? nil;
    self.description = paymentData["description"] ?? nil;
    self.ipAddress = paymentData["ipAddress"] ?? nil;
    self.cardholderName = paymentData["cardHolderName"] ?? nil;
    self.cultureName = paymentData["cultureName"] ?? nil;
    self.payer = paymentData["payer"] ?? nil;

    var arrayInformationUser: [String: String] = [:];

    if ((jsonData?["age"]) != nil) {
      arrayInformationUser["age"] = jsonData?["age"];
    }

    if ((jsonData?["name"]) != nil) {
      arrayInformationUser["name"] = jsonData?["name"];
    }

    if ((jsonData?["phone"]) != nil) {
      arrayInformationUser["phone"] = jsonData?["phone"];
    }

    self.jsonData = arrayInformationUser;
  }
}

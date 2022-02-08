import Foundation
import Cloudpayments;

func convertToPaymentData(paymentData: Dictionary<String, String>, jsonData: Dictionary<String, String>?) -> PaymentData {
  let publicId = paymentData["publicId"]!;
  let totalAmount = paymentData["totalAmount"]!;
  let accountId = paymentData["accountId"]!;
  let applePayMerchantId = paymentData["applePayMerchantId"]!;
  let currency = paymentData["currency"]!;

  let description = paymentData["description"];
  let ipAddress = paymentData["ipAddress"];
  let invoiceId = paymentData["invoiceId"];

  let options = convertRnJsonToSwiftArrayOption(jsonData: jsonData);

  let currencyConvert = Currency.init(rawValue: currency);

  let initialPaymentData = PaymentData.init(publicId: publicId)
    .setCurrency(currencyConvert!)
    .setAmount(totalAmount)
    .setAccountId(accountId)
    .setDescription(description)
    .setApplePayMerchantId(applePayMerchantId)
    .setIpAddress(ipAddress)
    .setInvoiceId(invoiceId)
    .setJsonData(options)

    return initialPaymentData;
}

private func convertRnJsonToSwiftArrayOption (jsonData: Dictionary<String, String>?) -> [String: String] {
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

  return arrayInformationUser;
}

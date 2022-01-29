import Cloudpayments;

@objc(CreditCardFormManager)
class CreditCardFormManager: NSObject {
  var paymentData: PaymentData!;

  public static var resolve: RCTPromiseResolveBlock!;
  public static var reject: RCTPromiseRejectBlock!;

  @objc
  func initialPaymentData (_ paymentData: Dictionary<String, String>, jsonData: Dictionary<String, String>?) -> Void {
    let publicId = paymentData["publicId"]!;
    let totalAmount = paymentData["totalAmount"]!;
    let accountId = paymentData["accountId"]!;
    let applePayMerchantId = paymentData["applePayMerchantId"]!;
    let currency = paymentData["currency"]!;

    let description = paymentData["description"];
    let ipAddress = paymentData["ipAddress"];
    let invoiceId = paymentData["invoiceId"];

    let options = self.convertRnJsonToSwiftArrayOption(jsonData);

    let currencyConvert = Currency.init(rawValue: currency);

    let initialData = PaymentData.init(publicId: publicId)
      .setCurrency(currencyConvert!)
      .setAmount(totalAmount)
      .setAccountId(accountId)
      .setDescription(description)
      .setApplePayMerchantId(applePayMerchantId)
      .setIpAddress(ipAddress)
      .setInvoiceId(invoiceId)
      .setJsonData(options)

    self.paymentData = initialData;
  }

  @objc
  func showCreditCardForm(_ configuration: Dictionary<String, Bool>, resolve:  @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    CreditCardFormManager.resolve = resolve;
    CreditCardFormManager.reject = reject;

    DispatchQueue.main.async {
      let cardFormController = CardFormController(paymentData: self.paymentData, configuration: configuration);
      cardFormController.showCreditCardForm();
    }
  }

  private func convertRnJsonToSwiftArrayOption (_ jsonData: Dictionary<String, String>?) -> [String: String] {
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

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

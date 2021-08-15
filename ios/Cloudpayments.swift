@objc(Cloudpayments)
class Cloudpayments: NSObject {
  private var resolve: RCTPromiseResolveBlock?;
  private var reject: RCTPromiseRejectBlock?;

  @objc
  func cardType(_ cardNumb: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    let cartType: String = Card.cardType(toString: Card.cardType(fromCardNumber: cardNumb))
    resolve(cartType);
  }

  @objc
  func isCardNumberValid(_ cardNumb: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    let isCardNumberValid: Bool = Card.isCardNumberValid(cardNumb);
    resolve(isCardNumberValid)
  }

  @objc
  func isExpDateValid(_ cardExpDate: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    let isExpDateValid: Bool = Card.isExpDateValid(cardExpDate)
    resolve(isExpDateValid)
  }

  @objc
  func cardCryptogramPacket(_ cardNumber: String, expDate: String, cvv: String, merchantId: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    let card = Card()
    let cardCryptogramPacket: String = card.makeCryptogramPacket(cardNumber, andExpDate: expDate, andCVV: cvv, andMerchantPublicID: merchantId);
    resolve(cardCryptogramPacket)
  }
    
  @objc
  func getBinInfo(_ cardNumber: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    self.resolve = resolve;
    self.reject = reject;
    let api: CPCardApi = CPCardApi.init()
    api.delegate = self;
    api.getBinInfo(cardNumber)
  }
}

extension Cloudpayments: CPCardApiDelegate {
  func didFinish(_ info: BinInfo!) {
    let bankInfo: NSMutableDictionary = [:];

    if let bankName = info.bankName {
      bankInfo["bankName"] = bankName;
    } else {
      self.reject?("Error", "BankName is empty", nil);
    }

    if let logoUrl = info.logoUrl {
      bankInfo["logoUrl"] = logoUrl;
    } else {
      self.reject?("Error", "LogoUrl is empty", nil);
    }

    self.resolve?(bankInfo);
  }

  func didFailWithError(_ message: String!) {
    self.reject?("Error", message, nil);
  }
}

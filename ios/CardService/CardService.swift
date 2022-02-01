import Cloudpayments

@objc(CardService)
class CardService: NSObject {
  @objc
  func cardType(_ cardNumb: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) -> Void {
    guard let _ = reject, let resolve = resolve else {
        return
    };

    let cardType: CardType = Card.cardType(from: cardNumb);
    resolve(cardType.toString());
  }

  @objc
  func isCardNumberValid(_ cardNumb: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) -> Void {
    guard let _ = reject, let resolve = resolve else {
        return
    };

    let isCardNumberValid: Bool = Card.isCardNumberValid(cardNumb);
    resolve(isCardNumberValid)
  }

  @objc
  func isExpDateValid(_ cardExpDate: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) -> Void {
    guard let _ = reject, let resolve = resolve else {
        return
    };

    let isExpDateValid: Bool = Card.isExpDateValid(cardExpDate)
    resolve(isExpDateValid)
  }

  @objc
  func makeCardCryptogramPacket(_ cardNumber: String, expDate: String, cvv: String, merchantId: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) -> Void {
    guard let _ = reject, let resolve = resolve else {
        return
    };

    let cardCryptogramPacket = Card.makeCardCryptogramPacket(with: cardNumber, expDate: expDate, cvv: cvv, merchantPublicID: merchantId);

    resolve(cardCryptogramPacket)
  }

  @objc
  func makeCardCryptogramPacket(_ cvv: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) -> Void {
    guard let _ = reject, let resolve = resolve else {
      return
    }

    let cvvCryptogramPacket = Card.makeCardCryptogramPacket(with: cvv);

    resolve(cvvCryptogramPacket);
  }

  @objc
  func getBinInfo(_ cardNumber: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    guard let reject = reject, let resolve = resolve else {
      return
    }

    CloudpaymentsApi.getBankInfo(cardNumber: cardNumber) { (info, error) in
      var bankInfo: Dictionary<String, String?> = [:];

      if let error = error {
        reject("Error", error.message, nil);
      } else {
        bankInfo["bankName"] = info?.bankName;
        bankInfo["logoUrl"] = info?.logoUrl;

        resolve(bankInfo);
      }
    }
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

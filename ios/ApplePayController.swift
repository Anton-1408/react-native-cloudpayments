import Foundation

@objc(ApplePayController)
class ApplePayController: RCTViewManager {
  private var window = UIApplication.shared.windows[0];
  private var paymentNetworks: Array<PKPaymentNetwork> = [];
  private let requestPay = PKPaymentRequest();

  @objc
  func setPaymentNetworks(_ paymentNetworks: Array<String>) -> Void {
    var listPaymentNetwork: Array<PKPaymentNetwork> = [];
    for paymentNetwork in paymentNetworks {
      let networkPay = checkPaymentNetwork(paymentNetwork);
      listPaymentNetwork.append(networkPay);
    }
    self.paymentNetworks = listPaymentNetwork;
  }

  @objc
  func canMakePayments(_ resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    let isCanMakePayments = PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: self.paymentNetworks)
    resolve(isCanMakePayments);
  }

  @objc
  func setProducts(_ products: Array<NSDictionary>) {
    var listProducts: Array<PKPaymentSummaryItem> = [];
    for product in products {
      let nameProduct = product.value(forKey: "name") as! String;
      let priceProduct = Int(product.value(forKey: "price") as! String);
      let paymentItem = PKPaymentSummaryItem.init(label: nameProduct, amount: NSDecimalNumber(value: priceProduct!));
      listProducts.append(paymentItem);
    }
    self.requestPay.paymentSummaryItems = listProducts;
  }

  @objc
  func setRequestPay(_ countryCode: String, currencyCode: String, merchantId: String) -> Void {
    self.requestPay.merchantIdentifier = merchantId;
    self.requestPay.supportedNetworks = self.paymentNetworks;
    self.requestPay.merchantCapabilities = PKMerchantCapability.capability3DS;
    self.requestPay.countryCode = countryCode;
    self.requestPay.currencyCode = currencyCode;
  }

  @objc
  func openApplePay() -> Void {
    DispatchQueue.main.async {
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: self.requestPay)
        applePayController?.delegate = self;
      self.window.rootViewController?.present(applePayController!, animated: true, completion: nil);
    }
  }

  private func checkPaymentNetwork(_ paymentNetwork: String) -> PKPaymentNetwork {
    switch paymentNetwork {
      case "VISA":
        return PKPaymentNetwork.visa;
      case "MASTERCARD":
        return PKPaymentNetwork.masterCard;
      case "AMEX":
        return PKPaymentNetwork.amex;
      case "INTERAC":
        return PKPaymentNetwork.interac;
      case "DISCOVER":
        return PKPaymentNetwork.discover;
      case "MIR":
        if #available(iOS 14.5, *) {
            return PKPaymentNetwork.mir
        } else {
            return PKPaymentNetwork.visa;
        };
      case "JCB":
        if #available(iOS 10.1, *) {
            return PKPaymentNetwork.JCB
        } else {
            return PKPaymentNetwork.visa;
        };
      default:
        return PKPaymentNetwork.visa;
    }
  }

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

extension ApplePayController: PKPaymentAuthorizationViewControllerDelegate {
  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    controller.dismiss(animated: true, completion: nil)
  }

  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
    guard let cryptogram = PKPaymentConverter.convert(toString: payment) else {
          return
    }
    EventEmitter.emitter.sendEvent(withName: "listenerCryptogramCard", body: cryptogram);
  }
}

import Foundation
import PassKit

@objc(ApplePayController)
class ApplePayController: NSObject {
  private var paymentNetworks: Array<PKPaymentNetwork> = [];
  private let requestPay = PKPaymentRequest();

  @objc
  func setPaymentNetworks(_ paymentNetworks: Array<String>) -> Void {
    var listPaymentNetwork: Array<PKPaymentNetwork> = [];
    for paymentNetwork in paymentNetworks {
      guard let networkPay = checkPaymentNetwork(paymentNetwork) else {
        continue
      };

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
  func setProducts(_ products: Array<Dictionary<String, String>>) {
    var listProducts: Array<PKPaymentSummaryItem> = [];
    for product in products {
      let nameProduct = product["name"]!;
      let priceProduct = Int(product["price"]!);
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
    self.requestPay.merchantCapabilities = [.capability3DS, .capabilityEMV];
  }

  @objc
  func openApplePay() -> Void {
    DispatchQueue.main.async {
      guard let rootViewController = RCTPresentedViewController() else {
        return
      }

      let applePayController = PKPaymentAuthorizationViewController(paymentRequest: self.requestPay)
      applePayController?.delegate = self;
      rootViewController.present(applePayController!, animated: true, completion: nil);
    }
  }

  private func checkPaymentNetwork(_ paymentNetwork: String) -> PKPaymentNetwork? {
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
            return nil;
        };
      case "JCB":
        if #available(iOS 10.1, *) {
            return PKPaymentNetwork.JCB
        } else {
            return nil;
        };
      default:
        return PKPaymentNetwork.visa;
    }
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

extension ApplePayController: PKPaymentAuthorizationViewControllerDelegate {
  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    controller.dismiss(animated: true, completion: nil)
  }

  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {

    guard let cryptogram = payment.convertToString() else {
      completion(PKPaymentAuthorizationStatus.failure)
      return
    }

    EventEmitter.emitter.sendEvent(withName: "listenerCryptogramCard", body: cryptogram);
    completion(PKPaymentAuthorizationStatus.success)
  }
}

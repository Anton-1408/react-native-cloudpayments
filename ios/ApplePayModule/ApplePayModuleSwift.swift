import Foundation
import PassKit
import React

@objc(ApplePayModuleSwift)
public class ApplePayModuleSwift: NSObject {
  private var paymentNetworks: Array<PKPaymentNetwork> = [];
  private let requestPay = PKPaymentRequest();
  private var onSendCryptogramCard: ((String) -> Void)?;
  
  @objc
  public static let shared = ApplePayModuleSwift()
  
  @objc
  private override init() {
    super.init()
  }

  @objc
  public func initialization(_ methodData: Dictionary<String, Any>, eventEmitter: @escaping (String) -> Void) -> Void {
    let initialData = MethodData.init(methodData: methodData);

    self.setPaymentNetworks(paymentNetworks: initialData.supportedNetworks);
    self.setRequestPay(countryCode: initialData.countryCode, currencyCode: initialData.currencyCode, merchantId: initialData.merchantId)
  
    self.onSendCryptogramCard = eventEmitter
  }

  private func setPaymentNetworks(paymentNetworks: Array<String>) -> Void {
    var listPaymentNetwork: Array<PKPaymentNetwork> = [];
    
    for paymentNetwork in paymentNetworks {
      guard let networkPay = checkPaymentNetwork(paymentNetwork) else {
        continue
      };

      listPaymentNetwork.append(networkPay);
    }
    
    self.paymentNetworks = listPaymentNetwork;
  }

  private func setRequestPay(countryCode: String, currencyCode: String, merchantId: String) -> Void {
    self.requestPay.merchantIdentifier = merchantId;
    self.requestPay.supportedNetworks = self.paymentNetworks;

    //безопасный способ обработки дебетовых и кредитных карт
    self.requestPay.merchantCapabilities = PKMerchantCapability.capability3DS;
    self.requestPay.countryCode = countryCode;
    self.requestPay.currencyCode = currencyCode;

    //capabilityEMV поддержка транзакций China Union Pay
    //capability3DS поддержка 3-D Secure protocol
    self.requestPay.merchantCapabilities = [.capability3DS, .capabilityEMV];
  }

  @objc
  public func canMakePayments(_ resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) -> Void {
    guard let reject = reject, let resolve = resolve else {
        return
    };

    guard !self.paymentNetworks.isEmpty else {
      reject("error", "PaymentNetworks is empty", nil)
      return;
    }

    let isCanMakePayments = PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: self.paymentNetworks)
    
    resolve(isCanMakePayments);
  }

  @objc
  public func setProducts(_ products: Array<Dictionary<String, String>>) {
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
  public func open() -> Void {
    // вызов операций в основном потоке
    RCTExecuteOnMainQueue {
      // получаем главный ViewController
      guard let rootViewController = RCTPresentedViewController() else {
        return
      }

      // инициализируем контроллер в переменную
      let applePayController = PKPaymentAuthorizationViewController(paymentRequest: self.requestPay)
      // получение выполнения оплаты будет осуществляться в текущем контроллере
      // делегируем работу на текущий контроллер
      applePayController?.delegate = self;
      //запускаем контроллер для выполнения оплаты через apple pay
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
}

// реализация методов делегирования класса
// получаем рузультат и отправляем через native events
extension ApplePayModuleSwift: PKPaymentAuthorizationViewControllerDelegate {
  public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    controller.dismiss(animated: true, completion: nil)
  }

  public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {

    guard let cryptogram = payment.convertToString() else {
      completion(PKPaymentAuthorizationStatus.failure)
      return
    }

    self.onSendCryptogramCard?(cryptogram)
    
    completion(PKPaymentAuthorizationStatus.success)
  }
}


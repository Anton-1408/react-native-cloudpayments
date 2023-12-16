//
//  PaymentFormManager.swift
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 17.09.2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import Cloudpayments;

@objc(PaymentFormManager)
final class PaymentFormManager: NSObject {
  @objc var bridge: RCTBridge!

  private var paymentData: PaymentData?;
  private var publicId: String = ""
  private var apiUrl: String = ""

  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;

  @objc
  func initialization(_ paymentData: Dictionary<String, String>) -> Void {
    let dataParsed = parseDictionaryToStruct(dictionary: paymentData, type: InitionalPaymentData.self)

    if let initialData = dataParsed {
      let applePayMerchantId = initialData.applePayMerchantId ?? "";
      let yandexPayMerchantId = initialData.yandexPayMerchantId ?? "";

      self.publicId = initialData.publicId
      self.apiUrl = initialData.apiUrl

      self.paymentData = PaymentData.init()
          .setAccountId(initialData.accountId)
          .setApplePayMerchantId(applePayMerchantId)
          .setIpAddress(initialData.ipAddress)
          .setCardholderName(initialData.cardholderName)
          .setYandexPayMerchantId(yandexPayMerchantId)
          .setEmail(initialData.email)
          .setCultureName(initialData.cultureName)
          .setDescription(initialData.description)

      do {
        let payer = try PaymentDataPayer.init(from: initialData.payer as! Decoder);
        self.paymentData?.setPayer(payer)
      } catch {
        print("payer init", error)
      }

      let hasInformationAboutPaymentOfProduct = initialData.amount != nil && initialData.currency != nil && initialData.invoiceId != nil

      guard hasInformationAboutPaymentOfProduct else {
        print("hasInformationAboutPaymentOfProduct = ", "false")
        return
      }

      self.paymentData?
        .setCurrency(initialData.currency!)
        .setAmount(initialData.amount!)
        .setInvoiceId(initialData.invoiceId!)
    }
  }

  @objc
  func setInformationAboutPaymentOfProduct(_ details: Dictionary<String, String>) -> Void {
    let dataParsed = parseDictionaryToStruct(dictionary: details, type: Payment.self)

    if let initialData = dataParsed {
      self.paymentData?
        .setCurrency(initialData.currency)
        .setAmount(initialData.amount)
        .setDescription(initialData.description)
        .setInvoiceId(initialData.invoiceId)
    }
  }

  @objc
  func open(_ configuration: Dictionary<String, Bool>, resolve:  @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    guard let paymentData = self.paymentData else {
      reject("error", "Error initial paymentData", nil);
      return;
    }

    PaymentFormManager.resolve = resolve;
    PaymentFormManager.reject = reject;

    let dataParsed = parseDictionaryToStruct(dictionary: configuration, type: ConfigurationPaymentForm.self)

    if let configurationData = dataParsed {
      let paymentFormController = PaymentFormController(
        paymentData: paymentData,
        configuration: configurationData,
        publicId: publicId,
        apiUrl: apiUrl
      );

      paymentFormController.onShow();
    }
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc
  func methodQueue() -> DispatchQueue {
    return .main
  }
}

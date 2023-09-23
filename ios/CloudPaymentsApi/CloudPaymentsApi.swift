//
//  CloudPaymentsApi.swift
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 05.02.2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation
import CloudpaymentsNetworking;
import Cloudpayments;

@objc(CloudPaymentsApi)
final class CloudPaymentsApi: NSObject {
  @objc var bridge: RCTBridge!

  private var api: CloudpaymentsApi?;
  private var paymentData: PaymentData?;

  @objc
  func initialization(_ paymentData: Dictionary<String, String>) -> Void {
    let dataParsed = parseDictionaryToStruct(dictionary: paymentData, type: InitionalPaymentData.self)

    if let initialData = dataParsed {
      self.api = CloudpaymentsApi(publicId: initialData.publicId, apiUrl: initialData.apiUrl);

      let applePayMerchantId = initialData.applePayMerchantId ?? "";
      let yandexPayMerchantId = initialData.yandexPayMerchantId ?? "";

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
  func auth(_ cardCryptogramPacket: String, email: String?, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) -> Void {
    guard let reject = reject, let resolve = resolve else {
        return
    };

    guard let api = self.api, let paymentData = self.paymentData else {
        reject("Error", "error initial data", nil);
        return;
    };

    api.auth(cardCryptogramPacket: cardCryptogramPacket, email: email, paymentData: paymentData, completion: {(response, error) in
        if let response = response {
          let result = parseResponseFromApiToDictionary(response: response)

          resolve(result);
        } else if let error = error {
          print("auth", error);

          reject("Error", error.localizedDescription, nil);
        }
    })
  }

  @objc
  func charge(_ cardCryptogramPacket: String, email: String?, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) -> Void {
    guard let reject = reject, let resolve = resolve else {
        return
    };

    guard let api = self.api, let paymentData = self.paymentData else {
        reject("Error", "error initial data", nil);
        return;
    };

    api.charge(cardCryptogramPacket: cardCryptogramPacket, email: email, paymentData: paymentData, completion: {(response, error) in
        if let response = response {
            let result = parseResponseFromApiToDictionary(response: response)

            resolve(result);
        } else if let error = error {
          print("charge", error);

          reject("Error", error.localizedDescription, nil);
        }
    })
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

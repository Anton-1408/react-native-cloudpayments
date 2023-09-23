//
//  Models.swift
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 17.09.2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import Cloudpayments;

struct ApplePayMethodData: Decodable {
  let merchantId: String
  let supportedNetworks: Array<String>
  let countryCode: String
  let currencyCode: String
}

struct Parametres3DS: Decodable {
  let transactionId: String
  let paReq: String
  let acsUrl: String
}

struct InitionalPaymentData: Decodable {
  let publicId: String
  let email: String?
  let applePayMerchantId: String?
  let yandexPayMerchantId: String?
  let cardholderName: String?
  let accountId: String?
  let ipAddress: String?
  let cultureName: String?
  let jsonData: String?
  let payer: Payer?
  let apiUrl: String

  let amount: String?
  let currency: String?
  let invoiceId: String?
  let description: String?
}

struct Payer: Decodable {
  let firstName: String
  let lastName: String
  let middleName: String
  let birth: String
  let address: String
  let street: String
  let city: String
  let country: String
  let phone: String
  let postcode: String
}

struct Payment: Decodable {
  let amount: String
  let currency: String
  let invoiceId: String?
  let description: String?
}

struct ConfigurationPaymentForm: Decodable {
  let useDualMessagePayment: Bool
  let disableApplePay: Bool
  let disableYandexPay: Bool
}

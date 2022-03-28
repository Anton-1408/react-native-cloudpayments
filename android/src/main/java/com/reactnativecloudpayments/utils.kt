package com.reactnativecloudpayments

import com.facebook.react.bridge.ReadableMap


data class InitialPaymentData(var paymentData: ReadableMap, val jsonDataParams: String?) {
  var publicId: String = paymentData.getString("publicId") as String;
  var totalAmount: String = paymentData.getString("totalAmount") as String;
  var accountId: String? = paymentData.getString("accountId");
  var currency: String = paymentData.getString("currency") as String;
  var description: String? = paymentData.getString("description");
  var ipAddress: String  = paymentData.getString("ipAddress") as String;
  var invoiceId: String? = paymentData.getString("invoiceId");
  var cardHolderName: String = paymentData.getString("cardHolderName") as String;
  var jsonData: String? = jsonDataParams;
}

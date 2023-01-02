package com.reactnativecloudpayments

import com.facebook.react.bridge.ReadableMap
import com.fasterxml.jackson.databind.ObjectMapper

// Класс для хранения payment data

data class InitialPaymentData(var paymentData: ReadableMap) {
  var publicId: String = paymentData.getString("publicId") as String;
  var accountId: String? = paymentData.getString("accountId");
  var description: String? = paymentData.getString("description");
  var ipAddress: String?  = paymentData.getString("ipAddress");
  var invoiceId: String? = paymentData.getString("invoiceId");
  var cardHolderName: String? = paymentData.getString("cardHolderName");
  var yandexPayMerchantID: String = paymentData.getString("yandexPayMerchantID") as String;

  lateinit var jsonDataHash: HashMap<String, Any>

  fun setJsonData(jsonDataString: String) {
    val objectMapper = ObjectMapper();
    jsonDataHash = objectMapper.readValue(jsonDataString, Map::class.java) as HashMap<String, Any>;
  }

  lateinit var totalAmount: String
  lateinit var currency: String
}

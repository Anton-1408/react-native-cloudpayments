package com.reactnativecloudpayments

import com.facebook.react.bridge.ReadableMap

data class InitionalPaymentData(val paymentData: ReadableMap) {
  val publicId: String = paymentData.getString("publicId") as String
  val email: String? = paymentData.getString("email")
  val yandexPayMerchantID: String = paymentData.getString("yandexPayMerchantID") ?: ""
  val cardholderName: String = paymentData.getString("cardHolderName") ?: ""
  val accountId: String? = paymentData.getString("accountId")
  val ipAddress: String  = paymentData.getString("ipAddress") ?: ""
  var description: String? = paymentData.getString("description")
  val cultureName: String? = paymentData.getString("cultureName")
  val jsonData: String? = paymentData.getString("jsonData")
  var invoiceId: String? = paymentData.getString("invoiceId")
  val apiUrl: String? = paymentData.getString("apiUrl")
  var payer: Payer = Payer(paymentData.getMap("payer"))

  lateinit var amount: String
  lateinit var currency: String
}

data class Payer(val payer: ReadableMap?) {
  val firstName: String? = payer?.getString("firstName")
  val lastName: String? = payer?.getString("lastName")
  val middleName: String? = payer?.getString("middleName")
  val birthDay: String? = payer?.getString("birthDay")
  val address: String? = payer?.getString("address")
  val street: String? = payer?.getString("street")
  val city: String? = payer?.getString("city")
  val country: String? = payer?.getString("country")
  val phone: String? = payer?.getString("phone")
  val postcode: String? = payer?.getString("postcode")
}

data class Payment(val payment: ReadableMap) {
  val amount: String = payment.getString("totalAmount") as String
  val currency: String = payment.getString("currency") as String
  val invoiceId: String? = payment.getString("invoiceId")
  val description: String? = payment.getString("description")
}

data class ConfigurationPaymentForm(val configuration: ReadableMap) {
  val disableGPay: Boolean = configuration.getBoolean("disableGPay") as Boolean
  val useDualMessagePayment: Boolean = configuration.getBoolean("useDualMessagePayment") as Boolean
  val disableYandexPay: Boolean = configuration.getBoolean("disableYandexPay") as Boolean
}

package com.cloudpaymentssdk

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap

data class Payer(val payer: ReadableMap) {
  val firstName: String? = payer.getString("firstName")
  val lastName: String? = payer.getString("lastName")
  val middleName: String? = payer.getString("middleName")
  val birthDay: String? = payer.getString("birthDay")
  val address: String? = payer.getString("address")
  val street: String? = payer.getString("street")
  val city: String? = payer.getString("city")
  val country: String? = payer.getString("country")
  val phone: String? = payer.getString("phone")
  val postcode: String? = payer.getString("postcode")
}

data class DataRecurrent(val dataRecurrent: ReadableMap?) {
  val interval: String = dataRecurrent?.getString("interval") ?: ""
  val period: Int = dataRecurrent?.getInt("period") ?: 0
  val maxPeriods: Int = dataRecurrent?.getInt("maxPeriods") ?: 0
  val startDate: String = dataRecurrent?.getString("startDate") ?: ""
  val amount: Double = dataRecurrent?.getDouble("amount") ?: 0.0
}

data class ReceiptAmounts(val receiptAmounts: ReadableMap) {
  val electronic: Double = receiptAmounts.getDouble("electronic")
  val advancePayment: Double = receiptAmounts.getDouble("advancePayment")
  val credit: Double = receiptAmounts.getDouble("credit")
  val provision: Double = receiptAmounts.getDouble("provision")
}

data class DataReceiptItem(val receiptItem: ReadableMap?) {
  val label: String = receiptItem?.getString("label") ?: ""
  val price: Double = receiptItem?.getDouble("price") ?: 0.0
  val quantity: Double = receiptItem?.getDouble("quantity") ?: 0.0
  val amount: Double = receiptItem?.getDouble("amount") ?: 0.0
  val vat: Int = receiptItem?.getInt("vat") ?: 0
  val method: Int = receiptItem?.getInt("method") ?: 0
  val objectt: Int = receiptItem?.getInt("objectt") ?: 0
}

data class DataPaymentReceipt(val dataPaymentReceipt: ReadableMap) {
  val taxationSystem: Int = dataPaymentReceipt.getInt("taxationSystem")
  val email: String = dataPaymentReceipt.getString("email") ?: ""
  val phone: String = dataPaymentReceipt.getString("phone") ?: ""
  val isBso: Boolean = dataPaymentReceipt.getBoolean("isBso")
}

data class Payment(val payment: ReadableMap) {
  val amount: String = payment.getString("totalAmount") ?: ""
  val currency: String = payment.getString("currency") ?: ""
  val accountId: String? = payment.getString("accountId")
  val description: String? = payment.getString("description")
  val email: String? = payment.getString("email")
}

data class ConfigurationPaymentForm(val configuration: ReadableMap) {
  val publicId: String = configuration.getString("publicId") ?: ""
  val requireEmail: Boolean = configuration.getBoolean("requireEmail") as Boolean
  val useDualMessagePayment: Boolean = configuration.getBoolean("useDualMessagePayment") as Boolean
  val showResultScreenForSinglePaymentMode: Boolean = configuration.getBoolean("showResultScreenForSinglePaymentMode")
  val saveCardForSinglePaymentMode: Boolean = configuration.getBoolean("saveCardForSinglePaymentMode")
  val testMode: Boolean = configuration.getBoolean("testMode")
  val mode: String = configuration.getString("mode") ?: ""
}

data class Parameters3DS(val params: ReadableMap) {
  val acsUrl: String = params.getString("acsUrl") as String;
  val paReq: String = params.getString("paReq") as String
  val md: String = params.getString("md") as String
}

data class GooglePayMethodData(val params: ReadableMap) {
  val environmentRunning: String = params.getString("environmentRunning") as String;
  val merchantName: String = params.getString("merchantName") as String
  val googlePayMerchantId: String = params.getString("merchantId") as String
  val gateway = Gateway(params.getMap("gateway") as ReadableMap)
  val countryCode: String = params.getString("countryCode") as String;
  val currencyCode = params.getString("currencyCode") as String;
  val supportedNetworks = params.getArray("supportedNetworks") as ReadableArray
}

data class Gateway(val gateway: ReadableMap) {
  val gatewayName = gateway.getString("service") as String;
  val gatewayMerchantId = gateway.getString("merchantId") as String;
}

data class Product(val product: ReadableMap?) {
  val name = product?.getString("name") ?: ""
  val price = product?.getString("price") ?: "0.0"
}

package com.cloudpaymentssdk

import android.app.Activity
import com.google.android.gms.wallet.PaymentsClient
import com.google.android.gms.wallet.Wallet
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

class GooglePayRequest (
  merchantName: String,
  googlePayMerchantId: String,
  gateway: Gateway,
  paymentNetworks: ArrayList<String>,
) {
  private var baseCardPaymentMethod: JSONObject = JSONObject();
  private var baseRequest: JSONObject = JSONObject();
  private var gatewayTokenizationSpecification: JSONObject = JSONObject();
  private var merchantInfo: JSONObject = JSONObject();
  private lateinit var paymentDataRequest: JSONObject;

  init {
    baseRequest.apply {
      put("apiVersion", 2)
      put("apiVersionMinor", 0)
    }

    gatewayTokenizationSpecification.apply {
      put("type", "PAYMENT_GATEWAY")
      put("parameters", JSONObject(mapOf(
        "gateway" to gateway.gatewayName,
        "gatewayMerchantId" to gateway.gatewayMerchantId)))
    }

    val allowedCardNetworks = JSONArray(paymentNetworks);

    val allowedCardAuthMethods = JSONArray(listOf(
      "PAN_ONLY",  // карты, хранящиеся в учетной записи Google
      "CRYPTOGRAM_3DS")) // карты, хранящиеся в виде токенов на устройстве

    baseCardPaymentMethod.apply {
      val parameters = JSONObject().apply {
        put("allowedAuthMethods", allowedCardAuthMethods)
        put("allowedCardNetworks", allowedCardNetworks)
        put("billingAddressRequired", true)
        put("billingAddressParameters", JSONObject().apply {
          put("format", "FULL")
        })
      }
      put("type", "CARD")
      put("parameters", parameters)
    }

    merchantInfo.put("merchantName", merchantName)
    merchantInfo.put("merchantId", googlePayMerchantId)
  }

  private fun cardPaymentMethod(): JSONObject {
    val cardPaymentMethod = baseCardPaymentMethod;
    cardPaymentMethod.put("tokenizationSpecification", gatewayTokenizationSpecification)

    return cardPaymentMethod
  }

  fun createPaymentsClient(activity: Activity, environmentRunning: Int): PaymentsClient {
    val walletOptions = Wallet.WalletOptions.Builder()
      .setEnvironment(environmentRunning)
      .build()

    return Wallet.getPaymentsClient(activity, walletOptions)
  }

  fun isReadyToPayRequest(): JSONObject? {
    return try {
      baseRequest.apply {
        put("allowedPaymentMethods", JSONArray().put(baseCardPaymentMethod))
      }
    } catch (e: JSONException) {
      null
    }
  }

  fun setTransactionInfo(countryCode: String, currencyCode: String, totalPrice: String) {
    paymentDataRequest = JSONObject().apply {
      put("totalPrice", totalPrice)
      put("totalPriceStatus", "FINAL") // стоимость покупки окончательная и больше изменяться не будет
      put("countryCode", countryCode)
      put("currencyCode", currencyCode)
    }
  }

  fun getPaymentDataRequest(): JSONObject? {
    return try {
      baseRequest.apply {
        put("allowedPaymentMethods", JSONArray().put(cardPaymentMethod()))
        put("transactionInfo", paymentDataRequest)
        put("merchantInfo", merchantInfo)
      }
    } catch (e: JSONException) {
      null
    }
  }
}

package com.reactnativecloudpayments

import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import com.fasterxml.jackson.databind.ObjectMapper


import ru.cloudpayments.sdk.configuration.CloudpaymentsSDK;
import ru.cloudpayments.sdk.api.CloudpaymentsApi;
import ru.cloudpayments.sdk.api.models.CloudpaymentsTransactionResponse
import ru.cloudpayments.sdk.api.models.PaymentRequestBody


import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers


@ReactModule(name = CloudPaymentsApi.MODULE_NAME)
class CloudPaymentsApi(reactContext: ReactApplicationContext): ReactContextBaseJavaModule(reactContext) {
  companion object {
    const val MODULE_NAME = "CloudPaymentsApi"
  }

  lateinit var paymentData: PaymentData;
  lateinit var api: CloudpaymentsApi;
  override fun getName() = MODULE_NAME

  @ReactMethod
  fun initApi(infoData: ReadableMap, jsonData: String?) {
    paymentData = PaymentData(infoData, jsonData);
    api = CloudpaymentsSDK.createApi(paymentData.publicId)
  }

  @ReactMethod
  fun charge(cardCryptogramPacket: String, email: String?, promise: Promise?) {
    val body = PaymentRequestBody(
      amount = paymentData.totalAmount,
      currency = paymentData.currency,
      ipAddress = paymentData.ipAddress,
      name = paymentData.cardHolderName,
      cryptogram = cardCryptogramPacket,
      jsonData = paymentData.jsonData,
      invoiceId = paymentData.invoiceId,
      description = paymentData.description,
      accountId = paymentData.accountId,
      email = email,
    )

    api.charge(body)
      .toObservable()
      .flatMap(CloudpaymentsTransactionResponse::handleError)
      .subscribeOn(Schedulers.io())
      .observeOn(AndroidSchedulers.mainThread())
      .subscribe({ results ->
        val objectMapper = ObjectMapper();
        val transaction = objectMapper.writeValueAsString(results)

        promise?.resolve(transaction);
      }, {error -> promise?.reject(error)})
  }

  @ReactMethod
  fun auth(cardCryptogramPacket: String, email: String?, promise: Promise?) {
    val body = PaymentRequestBody(
      amount = paymentData.totalAmount,
      currency = paymentData.currency,
      ipAddress = paymentData.ipAddress,
      name = paymentData.cardHolderName,
      cryptogram = cardCryptogramPacket,
      jsonData = paymentData.jsonData,
      invoiceId = paymentData.invoiceId,
      description = paymentData.description,
      accountId = paymentData.accountId,
      email = email,
    )

    api.auth(body)
      .toObservable()
      .flatMap(CloudpaymentsTransactionResponse::handleError)
      .subscribeOn(Schedulers.io())
      .observeOn(AndroidSchedulers.mainThread())
      .subscribe({ results ->
        val objectMapper = ObjectMapper();
        val transaction = objectMapper.writeValueAsString(results)

        promise?.resolve(transaction);
      }, {error -> promise?.reject(error)})
  }
}

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

  private lateinit var paymentData: InitialPaymentData;
  private lateinit var api: CloudpaymentsApi;
  private var jsonData: String? = null;

  override fun getName() = MODULE_NAME

  @ReactMethod
  fun initialization(infoData: ReadableMap, jsonData: String?) {
    paymentData = InitialPaymentData(infoData);
    api = CloudpaymentsSDK.createApi(paymentData.publicId)

    this.jsonData = jsonData;
  }

  @ReactMethod
  fun setInformationAboutPaymentOfProduct(details: ReadableMap) {
    val totalAmount = details.getString("totalAmount") as String;
    val currency = details.getString("currency") as String;
    val description = details.getString("description");
    val invoiceId = details.getString("invoiceId");

    paymentData.totalAmount = totalAmount;
    paymentData.currency = currency;
    paymentData.description = description;
    paymentData.invoiceId = invoiceId;
  }

  @ReactMethod
  fun charge(cardCryptogramPacket: String, email: String?, promise: Promise?) {
    val body = PaymentRequestBody(
      amount = paymentData.totalAmount,
      currency = paymentData.currency,
      ipAddress = paymentData.ipAddress ?: "",
      name = paymentData.cardHolderName ?: "",
      cryptogram = cardCryptogramPacket,
      jsonData = jsonData,
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
      }, {error -> promise?.reject("", error.message)})
  }

  @ReactMethod
  fun auth(cardCryptogramPacket: String, email: String?, promise: Promise?) {
    val body = PaymentRequestBody(
      amount = paymentData.totalAmount,
      currency = paymentData.currency,
      ipAddress = paymentData.ipAddress ?: "",
      name = paymentData.cardHolderName ?: "",
      cryptogram = cardCryptogramPacket,
      jsonData = jsonData,
      invoiceId = paymentData.invoiceId,
      description = paymentData.description,
      accountId = paymentData.accountId,
      email = email,
    )

    api.auth(body)
      .toObservable() // преобразование в Observable
      .flatMap(CloudpaymentsTransactionResponse::handleError) //  возращение результата Single
      .subscribeOn(Schedulers.io())
      .observeOn(AndroidSchedulers.mainThread())
      .subscribe({ results ->
        val objectMapper = ObjectMapper();
        val transaction = objectMapper.writeValueAsString(results)

        promise?.resolve(transaction);
      }, {error -> promise?.reject("", error.message)})
  }
}

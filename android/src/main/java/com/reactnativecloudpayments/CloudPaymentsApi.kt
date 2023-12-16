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
import ru.cloudpayments.sdk.api.models.PaymentDataPayer


@ReactModule(name = CloudPaymentsApi.MODULE_NAME)
class CloudPaymentsApi(reactContext: ReactApplicationContext): ReactContextBaseJavaModule(reactContext) {
  companion object {
    const val MODULE_NAME = "CloudPaymentsApi"
  }

  private lateinit var paymentData: InitionalPaymentData;
  private lateinit var api: CloudpaymentsApi;
  private val payer = PaymentDataPayer();

  override fun getName() = MODULE_NAME

  @ReactMethod
  fun initialization(infoData: ReadableMap) {
    paymentData = InitionalPaymentData(infoData);
    api = CloudpaymentsSDK.createApi(paymentData.publicId)

    payer.city = paymentData.payer.city
    payer.address = paymentData.payer.address
    payer.country = paymentData.payer.country
    payer.phone = paymentData.payer.phone
    payer.birthDay = paymentData.payer.birthDay
    payer.street = paymentData.payer.street
    payer.firstName = paymentData.payer.firstName
    payer.lastName = paymentData.payer.lastName
    payer.middleName = paymentData.payer.middleName
    payer.postcode = paymentData.payer.postcode
  }

  @ReactMethod
  fun setInformationAboutPaymentOfProduct(details: ReadableMap) {
    val payment = Payment(details);

    paymentData.amount = payment.amount;
    paymentData.currency = payment.currency;
    paymentData.description = payment.description;
    paymentData.invoiceId = payment.invoiceId;
  }

  @ReactMethod
  fun charge(cardCryptogramPacket: String, email: String?, promise: Promise?) {
    val body = PaymentRequestBody(
      amount = paymentData.amount,
      currency = paymentData.currency,
      ipAddress = paymentData.ipAddress,
      name = paymentData.cardholderName,
      cryptogram = cardCryptogramPacket,
      jsonData = paymentData.jsonData,
      invoiceId = paymentData.invoiceId,
      description = paymentData.description,
      accountId = paymentData.accountId,
      email = email,
      payer = this.payer,
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
      amount = paymentData.amount,
      currency = paymentData.currency,
      ipAddress = paymentData.ipAddress,
      name = paymentData.cardholderName,
      cryptogram = cardCryptogramPacket,
      jsonData = paymentData.jsonData,
      invoiceId = paymentData.invoiceId,
      description = paymentData.description,
      accountId = paymentData.accountId,
      email = email,
      payer = this.payer,
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

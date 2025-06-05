package com.cloudpaymentssdk

import android.annotation.SuppressLint
import com.facebook.react.bridge.*

import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers

import ru.cloudpayments.sdk.api.CloudpaymentsApi
import ru.cloudpayments.sdk.configuration.CloudpaymentsSDK;

class CloudPaymentsApi(reactContext: ReactApplicationContext): NativeCloudPaymentsAPISpec(reactContext) {
  companion object {
    const val MODULE_NAME = "CloudPaymentsApi"
  }

  private lateinit var api: CloudpaymentsApi;

  override fun getName() = MODULE_NAME

  override fun initialization(publicId: String) {
    api = CloudpaymentsSDK.createApi(publicId)
  }

  @SuppressLint("CheckResult")
  override fun getBinInfo(cardNumber: String, promise: Promise?) {
    api.getBinInfo(cardNumber)
      .subscribeOn(Schedulers.io())
      .observeOn(AndroidSchedulers.mainThread())
      .subscribe({ info ->
        val infoObject = Arguments.createMap()

        infoObject.putString("cardType", info.cardType)
        infoObject.putString("bankName", info.bankName)
        infoObject.putString("logoUrl", info.logoUrl)
        infoObject.putString("currency", info.currency)
        infoObject.putString("convertedAmount", info.convertedAmount)
        infoObject.putBoolean("hideCvv", info.hideCvv)

        promise?.resolve(infoObject)
      }, {error ->
        promise?.reject("error", error.message)}
      )
  }

  @SuppressLint("CheckResult")
  override fun getPublicKey(promise: Promise?) {
    api.getPublicKey()
      .subscribeOn(Schedulers.io())
      .observeOn(AndroidSchedulers.mainThread())
      .subscribe({ info ->
        val infoObject = Arguments.createMap()

        val version = info.version ?: 0
        val pem = info.pem

        infoObject.putString("pem", pem)
        infoObject.putInt("version", version)

        promise?.resolve(infoObject)
      }, {error ->
        promise?.reject("error", error.message)}
      )
  }
}

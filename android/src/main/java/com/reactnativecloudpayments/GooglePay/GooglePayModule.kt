package com.reactnativecloudpayments

import android.app.Activity
import android.content.Intent
import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.wallet.*
import org.json.JSONObject


@ReactModule(name = GooglePayModule.MODULE_NAME)
class GooglePayModule(reactContext: ReactApplicationContext): ReactContextBaseJavaModule(reactContext), ActivityEventListener {
  companion object {
    const val MODULE_NAME: String = "GooglePayModule"
    private var REQUEST_CODE_PAYMENT = 13  // код выполнения оплаты для отслеживания выполнения операции
  }

  override fun getName() = GooglePayModule.MODULE_NAME;

  lateinit var googlePayRequest: GooglePayRequest;
  lateinit var paymentsClient: PaymentsClient;
  lateinit var countryCode: String;
  lateinit var currencyCode: String;

  override fun onActivityResult(activity: Activity?, requestCode: Int, resultCode: Int, data: Intent?) {
    if (requestCode == REQUEST_CODE_PAYMENT) {
      if (resultCode == Activity.RESULT_OK) {
        data?.let { intent ->
          val paymentData = PaymentData.getFromIntent(intent);

          val paymentMethodData: JSONObject = JSONObject(paymentData?.toJson() as String).getJSONObject("paymentMethodData")
          val tokenGP = paymentMethodData.getJSONObject("tokenizationData").getString("token") as String;

          EventEmitter.sendEvent(reactApplicationContext, "listenerCryptogramCard",  tokenGP)
        }
      }
    }
  }

  override fun onNewIntent(intent: Intent?) = Unit

  @ReactMethod
  fun initialization(initialData: ReadableMap, paymentNetworks: ReadableArray) {
    val initialDataParsed = GooglePayMethodData(initialData);
    val paymentNetworksList = paymentNetworks.toArrayList();

    countryCode = initialDataParsed.countryCode;
    currencyCode = initialDataParsed.currencyCode;

    googlePayRequest = GooglePayRequest(
      initialDataParsed.merchantName,
      initialDataParsed.googlePayMerchantId,
      initialDataParsed.gateway,
      paymentNetworksList
    );

    val activity = currentActivity as Activity;

    paymentsClient = googlePayRequest.createPaymentsClient(activity, initialDataParsed.environmentRunning);

    reactApplicationContext.addActivityEventListener(this)
  }

  @ReactMethod
  fun setProducts(totalPrice: String) {
    googlePayRequest.setTransactionInfo(countryCode, currencyCode, totalPrice);
  }

  @ReactMethod
  fun canMakePayments(promise: Promise) {
    val isReadyToPayJson = googlePayRequest.isReadyToPayRequest() ?: return
    val request = IsReadyToPayRequest.fromJson(isReadyToPayJson.toString());
    val task = paymentsClient.isReadyToPay(request)

    task.addOnCompleteListener { completedTask ->
      try {
        if(completedTask.getResult(ApiException::class.java)) {
          promise.resolve(true);
        } else {
          promise.resolve(false);
        }
      } catch (exception: ApiException) {
        exception.printStackTrace()
        promise.resolve(false);
      }
    }
  }

  @ReactMethod
  fun open() {
    val paymentDataRequest: String = googlePayRequest.getPaymentDataRequest().toString()
    val request = PaymentDataRequest.fromJson(paymentDataRequest) // конвертация из json в класс дата

    AutoResolveHelper.resolveTask(paymentsClient.loadPaymentData(request), currentActivity!!, REQUEST_CODE_PAYMENT)
  }
}

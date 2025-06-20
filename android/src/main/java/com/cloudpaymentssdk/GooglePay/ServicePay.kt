package com.cloudpaymentssdk

import android.app.Activity
import android.content.Intent

import com.facebook.react.bridge.*

import com.google.android.gms.common.api.ApiException
import com.google.android.gms.wallet.*

import org.json.JSONObject

class ServicePay(reactContext: ReactApplicationContext): NativeServicePaySpec(reactContext), ActivityEventListener {
  companion object {
    const val MODULE_NAME: String = "ServicePay"
    private var REQUEST_CODE_PAYMENT = 13
  }

  override fun getName() = MODULE_NAME;

  lateinit var googlePayRequest: GooglePayRequest;
  lateinit var paymentsClient: PaymentsClient;
  lateinit var countryCode: String;
  lateinit var currencyCode: String;

  override fun onNewIntent(intent: Intent) = Unit

  init {
    reactApplicationContext.addActivityEventListener(this)
  }

  override fun onActivityResult(activity: Activity, requestCode: Int, resultCode: Int, data: Intent?) {
    if (requestCode == REQUEST_CODE_PAYMENT) {
      if (resultCode == Activity.RESULT_OK) {
        data?.let { intent ->
          val paymentData = PaymentData.getFromIntent(intent);

          val paymentMethodData: JSONObject = JSONObject(paymentData?.toJson() as String).getJSONObject("paymentMethodData")
          val tokenGP = paymentMethodData.getJSONObject("tokenizationData").getString("token") as String;

          emitOnServicePayToken(tokenGP)
        }
      }
    }
  }

  override fun initialization(initialData: ReadableMap) {
    val initialDataParsed = GooglePayMethodData(initialData);
    val paymentNetworksList = initialDataParsed.supportedNetworks.toArrayList() as ArrayList<String>;

    countryCode = initialDataParsed.countryCode;
    currencyCode = initialDataParsed.currencyCode;

    googlePayRequest = GooglePayRequest(
      initialDataParsed.merchantName,
      initialDataParsed.googlePayMerchantId,
      initialDataParsed.gateway,
      paymentNetworksList
    );

    val activity = currentActivity as Activity;
    val environmentRunning = if (initialDataParsed.environmentRunning === "Test") 3 else 1

    paymentsClient = googlePayRequest.createPaymentsClient(activity, environmentRunning);

    reactApplicationContext.addActivityEventListener(this)
  }

  override fun setProducts(products: ReadableArray) {
    var totalPrice: Double = 0.0

    for (index in 0 until products.size()) {
      val item = products.getMap(index)
      val product = Product(item)

      totalPrice += product.price.toDouble()
    }

    googlePayRequest.setTransactionInfo(countryCode, currencyCode, totalPrice.toString());
  }

  override fun canMakePayments(promise: Promise) {
    val isReadyToPayJson = googlePayRequest.isReadyToPayRequest() ?: return
    val request = IsReadyToPayRequest.fromJson(isReadyToPayJson.toString());
    val task = paymentsClient.isReadyToPay(request)

    task.addOnCompleteListener { completedTask ->
      try {
        if (completedTask.getResult(ApiException::class.java)) {
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

  override fun open() {
    val paymentDataRequest: String = googlePayRequest.getPaymentDataRequest().toString()
    val request = PaymentDataRequest.fromJson(paymentDataRequest)

    @Suppress("DEPRECATION")
    AutoResolveHelper.resolveTask(
      paymentsClient.loadPaymentData(request),
      currentActivity!!,
      REQUEST_CODE_PAYMENT
    )
  }
}

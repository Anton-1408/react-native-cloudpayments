package com.reactnativecloudpayments

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity

import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule

import ru.cloudpayments.sdk.configuration.CloudpaymentsSDK
import ru.cloudpayments.sdk.configuration.PaymentConfiguration
import ru.cloudpayments.sdk.configuration.PaymentData

@ReactModule(name = CreditCardForm.MODULE_NAME)
class CreditCardForm(reactContext: ReactApplicationContext): ReactContextBaseJavaModule(reactContext), ActivityEventListener  {
  companion object {
    const val MODULE_NAME: String = "CreditCardForm"
    private var REQUEST_CODE_PAYMENT = 69 // код выполнения оплаты для отслеживания выполнения операции
  }

  private lateinit var paymentDataInitialValues: InitialPaymentData;
  private lateinit var promise: Promise;

  override fun getName() = MODULE_NAME;

  // реализация метода onActivityResult для получение результата оплаты
  override fun onActivityResult(activity: Activity?, requestCode: Int, resultCode: Int, data: Intent?) {
    if (requestCode == REQUEST_CODE_PAYMENT) {
      // получение ответа с сервера
      val transactionId = data?.getIntExtra(CloudpaymentsSDK.IntentKeys.TransactionId.name, 0) ?: 0
      val transactionStatus = data?.getSerializableExtra(CloudpaymentsSDK.IntentKeys.TransactionStatus.name) as? CloudpaymentsSDK.TransactionStatus

      if (transactionStatus != null) {
        if (transactionStatus == CloudpaymentsSDK.TransactionStatus.Succeeded) {
          this.promise.resolve(transactionId);
        } else {
          val reasonCode = data.getIntExtra(CloudpaymentsSDK.IntentKeys.TransactionReasonCode.name, 0) ?: 0

          if (reasonCode > 0) {
            this.promise.reject(reasonCode.toString(), "Ошибка! Транзакция №$transactionId.");
          } else {
            this.promise.reject("", "Ошибка! Транзакция №$transactionId.");
          }
        }
      }
    }
  }

  // Unit эквивалентен void
  override fun onNewIntent(intent: Intent?) = Unit

  init {
    reactApplicationContext.addActivityEventListener(this)
  }

  @ReactMethod
  fun initialPaymentData(initialData: ReadableMap, jsonData: String?) {
    this.paymentDataInitialValues = InitialPaymentData(initialData);

    if (!jsonData.isNullOrEmpty()) {
      this.paymentDataInitialValues.setJsonData(jsonData);
    }
  }

  @ReactMethod
  fun setTotalAmount(totalAmount: String, currency: String) {
    paymentDataInitialValues.totalAmount = totalAmount;
    paymentDataInitialValues.currency = currency;
  }

  @ReactMethod
  fun showCreditCardForm(initialData: ReadableMap, promise: Promise) {
    this.promise = promise;

    val disableGPay = initialData.getBoolean("disableGPay")
    val useDualMessagePayment = initialData.getBoolean("useDualMessagePayment")

    val paymentData = PaymentData(
      paymentDataInitialValues.publicId,
      paymentDataInitialValues.totalAmount,
      currency = paymentDataInitialValues.currency,
      invoiceId = paymentDataInitialValues.invoiceId,
      accountId = paymentDataInitialValues.accountId,
      ipAddress = paymentDataInitialValues.ipAddress,
      description = paymentDataInitialValues.description,
      cardholderName = paymentDataInitialValues.cardHolderName,
      jsonData = paymentDataInitialValues.jsonDataHash
    )

    val configuration = PaymentConfiguration(
      paymentData,
      CardIOScanner(),
      useDualMessagePayment,
      disableGPay
    )

    val appCompatActivity = currentActivity as AppCompatActivity;

    // получаем экземпляр класса, запускае activity с оплатой из текущего activity
    CloudpaymentsSDK.getInstance().start(configuration, appCompatActivity, REQUEST_CODE_PAYMENT)
   }
}

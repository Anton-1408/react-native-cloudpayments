package com.reactnativecloudpayments

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity

import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import ru.cloudpayments.sdk.api.models.PaymentDataPayer

import ru.cloudpayments.sdk.configuration.CloudpaymentsSDK
import ru.cloudpayments.sdk.configuration.PaymentConfiguration
import ru.cloudpayments.sdk.configuration.PaymentData

@ReactModule(name = PaymentForm.MODULE_NAME)
class PaymentForm(reactContext: ReactApplicationContext): ReactContextBaseJavaModule(reactContext), ActivityEventListener  {
  companion object {
    const val MODULE_NAME: String = "PaymentForm"
    private var REQUEST_CODE_PAYMENT = 69 // код выполнения оплаты для отслеживания выполнения операции
  }

  private lateinit var paymentData: InitionalPaymentData;
  private val payer = PaymentDataPayer();

  private lateinit var promise: Promise;

  override fun getName() = MODULE_NAME;

  override fun onActivityResult(activity: Activity?, requestCode: Int, resultCode: Int, data: Intent?) {
    if (requestCode == REQUEST_CODE_PAYMENT) {
      // получение ответа с сервера
      val transactionId = data?.getIntExtra(CloudpaymentsSDK.IntentKeys.TransactionId.name, 0) ?: 0
      val transactionStatus = data?.getSerializableExtra(CloudpaymentsSDK.IntentKeys.TransactionStatus.name) as? CloudpaymentsSDK.TransactionStatus

      if (transactionStatus != null) {
        if (transactionStatus == CloudpaymentsSDK.TransactionStatus.Succeeded) {
          this.promise.resolve(transactionId);
        } else {
          val reasonCode = data.getIntExtra(CloudpaymentsSDK.IntentKeys.TransactionReasonCode.name, 0);

          if (reasonCode > 0) {
            this.promise.reject(reasonCode.toString(), "Ошибка! Транзакция №$transactionId.");
          } else {
            this.promise.reject("", "Ошибка! Транзакция №$transactionId.");
          }
        }
      }
    }
  }

  override fun onNewIntent(intent: Intent?) = Unit

  init {
    reactApplicationContext.addActivityEventListener(this)
  }

  @ReactMethod
  fun initialization(initialData: ReadableMap) {
    paymentData = InitionalPaymentData(initialData);

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
  fun open(initialConfiguration: ReadableMap, promise: Promise) {
    this.promise = promise;

    val disableGPay = initialConfiguration.getBoolean("disableGPay");
    val useDualMessagePayment = initialConfiguration.getBoolean("useDualMessagePayment");
    val disableYandexPay = initialConfiguration.getBoolean("disableYandexPay");

    val paymentData = PaymentData(
      amount = this.paymentData.amount,
      currency = this.paymentData.currency,
      invoiceId = this.paymentData.invoiceId,
      accountId = this.paymentData.accountId,
      description = this.paymentData.description,
      email = this.paymentData.email,
      payer = this.payer,
      jsonData = this.paymentData.jsonData
    )

    val configuration = PaymentConfiguration(
      publicId = this.paymentData.publicId,
      paymentData = paymentData,
      scanner = CardIOScanner(),
      useDualMessagePayment = useDualMessagePayment,
      disableGPay = disableGPay,
      disableYandexPay = disableYandexPay,
      yandexPayMerchantID = this.paymentData.yandexPayMerchantID
    )

    val appCompatActivity = currentActivity as AppCompatActivity;

    // получаем экземпляр класса, запускае activity с оплатой из текущего activity
    CloudpaymentsSDK.getInstance().start(configuration, appCompatActivity, REQUEST_CODE_PAYMENT)
  }
}

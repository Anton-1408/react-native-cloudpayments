package com.cloudpaymentssdk

import android.app.Activity
import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatActivity

import com.facebook.react.bridge.ActivityEventListener
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap

import ru.cloudpayments.sdk.api.models.PaymentDataPayer
import ru.cloudpayments.sdk.api.models.intent.CPReceipt
import ru.cloudpayments.sdk.api.models.intent.CPReceiptAmounts
import ru.cloudpayments.sdk.api.models.intent.CPReceiptItem
import ru.cloudpayments.sdk.api.models.intent.CPRecurrent
import ru.cloudpayments.sdk.configuration.CloudpaymentsSDK
import ru.cloudpayments.sdk.configuration.PaymentConfiguration
import ru.cloudpayments.sdk.configuration.PaymentData

class PaymentForm(reactContext: ReactApplicationContext): NativePaymentFormSpec(reactContext),
  ActivityEventListener {
  private val payer = PaymentDataPayer()
  private var recurrent: CPRecurrent? = null
  private var receipt: CPReceipt? = null
  private var paymentData: PaymentData? = null

  private var promise: Promise? = null;

  companion object {
    const val MODULE_NAME = "PaymentForm"
    private var REQUEST_CODE_PAYMENT = 12
  }

  override fun getName() = MODULE_NAME
  override fun onNewIntent(intent: Intent) = Unit

  init {
    reactApplicationContext.addActivityEventListener(this)
  }

  override fun onActivityResult(activity: Activity, requestCode: Int, resultCode: Int, data: Intent?) {
    if (requestCode == REQUEST_CODE_PAYMENT) {
      val transactionId = data?.getIntExtra(CloudpaymentsSDK.IntentKeys.TransactionId.name, 0) ?: 0
      val transactionStatus: CloudpaymentsSDK.TransactionStatus? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        data?.getSerializableExtra(
          CloudpaymentsSDK.IntentKeys.TransactionStatus.name,
          CloudpaymentsSDK.TransactionStatus::class.java
        )
      } else {
        @Suppress("DEPRECATION")
        data?.getSerializableExtra(CloudpaymentsSDK.IntentKeys.TransactionStatus.name) as? CloudpaymentsSDK.TransactionStatus
      }

      if (transactionStatus != null) {
        if (transactionStatus == CloudpaymentsSDK.TransactionStatus.Succeeded) {
          this.promise?.resolve(transactionId);
        } else {
          val reasonCode = data?.getIntExtra(CloudpaymentsSDK.IntentKeys.TransactionReasonCode.name, 0) ?: 0;

          if (reasonCode > 0) {
            this.promise?.reject(reasonCode.toString(), "Ошибка! Транзакция №$transactionId.");
          } else {
            this.promise?.reject("error", "Ошибка! Транзакция №$transactionId.");
          }
        }
      }
    }
  }

  override fun createPayer(initialData: ReadableMap) {
    val initialDataParsed = Payer(initialData)

    payer.firstName = initialDataParsed.firstName
    payer.lastName = initialDataParsed.lastName
    payer.middleName = initialDataParsed.middleName
    payer.birthDay = initialDataParsed.birthDay
    payer.address = initialDataParsed.address
    payer.street = initialDataParsed.street
    payer.city = initialDataParsed.city
    payer.country = initialDataParsed.country
    payer.phone = initialDataParsed.phone
    payer.postcode = initialDataParsed.postcode
  }

  override fun createDataReceipt(
    initialReceiptItems: ReadableArray,
    initialReceiptAmounts: ReadableMap,
    initialDataPaymentReceipt: ReadableMap
  ) {
    val receiptAmountsParsed = ReceiptAmounts(initialReceiptAmounts)
    val receiptItemsParsed = ArrayList<CPReceiptItem>()
    val dataPaymentReceiptParsed = DataPaymentReceipt(initialDataPaymentReceipt)

    for (index in 0 until initialReceiptItems.size()) {
      val item = initialReceiptItems.getMap(index)
      val receiptItemParsed = DataReceiptItem(item)

      val receiptItem = CPReceiptItem(
        label = receiptItemParsed.label,
        price = receiptItemParsed.price,
        quantity = receiptItemParsed.quantity,
        amount = receiptItemParsed.amount,
        vat = receiptItemParsed.vat,
        method = receiptItemParsed.method,
        objectt = receiptItemParsed.objectt
      )

      receiptItemsParsed.add(receiptItem)
    }

    val receiptAmounts = CPReceiptAmounts(
      electronic = receiptAmountsParsed.electronic,
      advancePayment = receiptAmountsParsed.advancePayment,
      credit = receiptAmountsParsed.credit,
      provision = receiptAmountsParsed.provision
    )

    receipt = CPReceipt(
      items = receiptItemsParsed,
      taxationSystem = dataPaymentReceiptParsed.taxationSystem,
      email = dataPaymentReceiptParsed.email,
      phone = dataPaymentReceiptParsed.phone,
      isBso = dataPaymentReceiptParsed.isBso,
      amounts = receiptAmounts
    )
  }

  override fun createDataRecurrent(initialData: ReadableMap) {
    val initialDataParsed = DataRecurrent(initialData)

    recurrent = CPRecurrent(
      interval = initialDataParsed.interval,
      period = initialDataParsed.period,
      maxPeriods = initialDataParsed.maxPeriods,
      startDate = initialDataParsed.startDate,
      amount = initialDataParsed.amount.toFloat(),
      customerReceipt = receipt
    )
  }

  override fun createPaymentData(initialPaymentData: ReadableMap) {
    val paymentDataParsed = Payment(initialPaymentData)

    paymentData = PaymentData(
      amount = paymentDataParsed.amount,
      currency = paymentDataParsed.currency,
      description = paymentDataParsed.description,
      accountId = paymentDataParsed.accountId,
      email = paymentDataParsed.email,
      payer = payer,
      receipt = receipt,
      recurrent = recurrent,
    )
  }

  override fun open(initialConfigurationData: ReadableMap, promise: Promise?) {
    val configurationDataParsed = ConfigurationPaymentForm(initialConfigurationData)
    val mode = when(configurationDataParsed.mode) {
      "SberPay" -> CloudpaymentsSDK.SDKRunMode.SberPay
      "SelectPaymentMethod" -> CloudpaymentsSDK.SDKRunMode.SelectPaymentMethod
      "SBP" -> CloudpaymentsSDK.SDKRunMode.SBP
      "TPay" -> CloudpaymentsSDK.SDKRunMode.TPay
      else ->  CloudpaymentsSDK.SDKRunMode.SelectPaymentMethod
    }

    val configuration = paymentData?.let {
      PaymentConfiguration(
        publicId = configurationDataParsed.publicId,
        paymentData = it,
        scanner = null,
        requireEmail = configurationDataParsed.requireEmail,
        useDualMessagePayment = configurationDataParsed.useDualMessagePayment,
        showResultScreenForSinglePaymentMode = configurationDataParsed.showResultScreenForSinglePaymentMode,
        saveCardForSinglePaymentMode = configurationDataParsed.saveCardForSinglePaymentMode,
        testMode = configurationDataParsed.testMode,
        mode = mode
      )
    }


    val appCompatActivity = currentActivity as AppCompatActivity;

    this.promise = promise

    if (configuration != null) {
      CloudpaymentsSDK.getInstance().start(configuration, appCompatActivity, REQUEST_CODE_PAYMENT)
    }
  }
}

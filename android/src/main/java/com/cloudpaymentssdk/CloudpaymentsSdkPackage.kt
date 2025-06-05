package com.cloudpaymentssdk

import com.facebook.react.BaseReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider

class CloudpaymentsSdkPackage : BaseReactPackage() {
  override fun getModule(name: String, reactContext: ReactApplicationContext): NativeModule? {
    return when (name) {
      ServicePay.MODULE_NAME -> ServicePay(reactContext)
      CardService.MODULE_NAME -> CardService(reactContext)
      ThreeDSecure.MODULE_NAME -> ThreeDSecure(reactContext)
      CloudPaymentsApi.MODULE_NAME -> CloudPaymentsApi(reactContext)
      PaymentForm.MODULE_NAME -> PaymentForm(reactContext)
      else -> null
    }
  }

  override fun getReactModuleInfoProvider() = ReactModuleInfoProvider {
    mapOf(
      ServicePay.MODULE_NAME to ReactModuleInfo(
        name = ServicePay.MODULE_NAME,
        className = ServicePay::class.java.name,
        canOverrideExistingModule = false,
        needsEagerInit = false,
        isCxxModule = false,
        isTurboModule = true
      ),
      CardService.MODULE_NAME to ReactModuleInfo(
        name = CardService.MODULE_NAME,
        className = CardService::class.java.name,
        canOverrideExistingModule = false,
        needsEagerInit = false,
        isCxxModule = false,
        isTurboModule = true
      ),
      ThreeDSecure.MODULE_NAME to ReactModuleInfo(
        name = ThreeDSecure.MODULE_NAME,
        className = ThreeDSecure::class.java.name,
        canOverrideExistingModule = false,
        needsEagerInit = false,
        isCxxModule = false,
        isTurboModule = true
      ),
      CloudPaymentsApi.MODULE_NAME to ReactModuleInfo(
        name = CloudPaymentsApi.MODULE_NAME,
        className = CloudPaymentsApi::class.java.name,
        canOverrideExistingModule = false,
        needsEagerInit = false,
        isCxxModule = false,
        isTurboModule = true
      ),
      PaymentForm.MODULE_NAME to ReactModuleInfo(
        name = PaymentForm.MODULE_NAME,
        className = PaymentForm::class.java.name,
        canOverrideExistingModule = false,
        needsEagerInit = false,
        isCxxModule = false,
        isTurboModule = true
      ),
    )
  }
}

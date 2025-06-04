package com.cloudpaymentssdk

import com.facebook.react.BaseReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider

class CloudpaymentsSdkPackage : BaseReactPackage() {
  override fun getModule(name: String, reactContext: ReactApplicationContext): NativeModule? {
    return when (name) {
      GooglePayModule.MODULE_NAME -> GooglePayModule(reactContext)
      CardService.MODULE_NAME -> CardService(reactContext)
      ThreeDSecure.MODULE_NAME -> ThreeDSecure(reactContext)
      else -> null
    }
  }

  override fun getReactModuleInfoProvider() = ReactModuleInfoProvider {
    mapOf(
      GooglePayModule.MODULE_NAME to ReactModuleInfo(
        name = GooglePayModule.MODULE_NAME,
        className = GooglePayModule::class.java.name,
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
    )
  }
}

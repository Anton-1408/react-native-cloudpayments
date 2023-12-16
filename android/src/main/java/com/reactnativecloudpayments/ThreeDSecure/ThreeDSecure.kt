package com.reactnativecloudpayments

import android.content.Intent

import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule


@ReactModule(name = CardService.MODULE_NAME)
class ThreeDSecure(reactContext: ReactApplicationContext): ReactContextBaseJavaModule(reactContext)/*, ThreeDsDialogFragment.ThreeDSDialogListener*/ {
  companion object {
    const val MODULE_NAME: String = "ThreeDSecure";
    lateinit var promise: Promise;
  }

  override fun getName() = MODULE_NAME;

  @ReactMethod
  fun request(params3DS: ReadableMap, promise: Promise) {
    val params3DSParsed = Parametres3DS(params3DS)

    ThreeDSecure.promise = promise;

    // действие для запуска нового экрана (из текущего в ThreeDSecureActivity)
    val intent = Intent(currentActivity, ThreeDSecureActivity::class.java);

    //передаем параметры
    intent.putExtra("acsUrl", params3DSParsed.acsUrl);
    intent.putExtra("paReq", params3DSParsed.paReq);
    intent.putExtra("md", params3DSParsed.md);

    // переключаемся на новый экран
    currentActivity?.startActivity(intent);
  }
}

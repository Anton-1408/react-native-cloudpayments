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
  fun requestThreeDSecure(parametres3DS: ReadableMap, promise: Promise) {
    val acsUrl = parametres3DS.getString("acsUrl") as String;
    val paReq = parametres3DS.getString("paReq") as String;
    val md = parametres3DS.getString("transactionId") as String;

    ThreeDSecure.promise = promise;

    val intent = Intent(currentActivity, ThreeDSecureActivity::class.java);

    intent.putExtra("acsUrl", acsUrl);
    intent.putExtra("paReq", paReq);
    intent.putExtra("md", md);

    currentActivity?.startActivity(intent);
  }
}

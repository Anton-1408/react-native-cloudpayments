package com.cloudpaymentssdk

import android.content.Intent
import com.facebook.react.bridge.*

class ThreeDSecure(reactContext: ReactApplicationContext): NativeThreeDSecureSpec(reactContext) {
  companion object {
    const val MODULE_NAME: String = "ThreeDSecure";
    var promise: Promise? = null;
  }

  override fun getName() = MODULE_NAME;

  override fun request(params3DS: ReadableMap, promise: Promise?) {
    val params3DSParsed = Parameters3DS(params3DS)

    ThreeDSecure.promise = promise;

    val intent = Intent(currentActivity, ThreeDSecureActivity::class.java);

    intent.putExtra("acsUrl", params3DSParsed.acsUrl);
    intent.putExtra("paReq", params3DSParsed.paReq);
    intent.putExtra("md", params3DSParsed.md);

    currentActivity?.startActivity(intent);
  }
}

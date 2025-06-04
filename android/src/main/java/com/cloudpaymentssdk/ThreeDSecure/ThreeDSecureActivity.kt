package com.cloudpaymentssdk

import org.json.JSONObject;
import androidx.fragment.app.FragmentActivity

import ru.cloudpayments.sdk.ui.dialogs.ThreeDsDialogFragment

class ThreeDSecureActivity: FragmentActivity(), ThreeDsDialogFragment.ThreeDSDialogListener {
  val promise = ThreeDSecure.promise;

  override fun onAuthorizationCompleted(md: String, paRes: String) {
    val result = JSONObject();

    result.put("md", md);
    result.put("paRes", paRes);

    promise?.resolve(result.toString());
    finish()
  }

  override fun onAuthorizationFailed(error: String?) {
    promise?.reject("error", error);
    finish()
  }

  override fun onStart() {
    super.onStart()

    val acsUrl = intent.getStringExtra("acsUrl") as String;
    val paReq = intent.getStringExtra("paReq") as String;
    val md = intent.getStringExtra("md") as String;

    ThreeDsDialogFragment
      .newInstance(acsUrl, paReq, md)
      .show(supportFragmentManager, "3DS")
  }
}

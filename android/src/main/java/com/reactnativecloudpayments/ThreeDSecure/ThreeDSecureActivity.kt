package com.reactnativecloudpayments

import org.json.JSONObject;

import android.os.Bundle
import android.os.PersistableBundle

import androidx.fragment.app.FragmentActivity

import ru.cloudpayments.sdk.ui.dialogs.ThreeDsDialogFragment

class ThreeDSecureActivity: FragmentActivity(), ThreeDsDialogFragment.ThreeDSDialogListener {
  val promise = ThreeDSecure.promise;

  override fun onAuthorizationCompleted(md: String, paRes: String) {
    val result: JSONObject = JSONObject();
    result.put("TransactionId", md);
    result.put("PaRes", paRes);

    promise.resolve(result.toString());
    onBackPressed()
  }

  override fun onAuthorizationFailed(error: String?) {
    promise.reject("", error);
    onBackPressed()
  }

  override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
    super.onCreate(savedInstanceState, persistentState)
  }

  override fun onStart() {
    super.onStart()

    // получаей параметры
    val acsUrl = intent.getStringExtra("acsUrl");
    val paReq = intent.getStringExtra("paReq");
    val md = intent.getStringExtra("md");

    // запускаем экран для подтверждения оплаты
    ThreeDsDialogFragment
      .newInstance(acsUrl, paReq, md)
      .show(supportFragmentManager, "3DS")
  }
}

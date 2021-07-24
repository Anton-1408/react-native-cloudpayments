package com.reactnativecloudpayments;

import ru.cloudpayments.sdk.three_ds.ThreeDSDialogListener;
import ru.cloudpayments.sdk.three_ds.ThreeDsDialogFragment;

import android.os.Bundle;
import android.content.Intent;

import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import org.json.JSONException;
import org.json.JSONObject;

public class ThreeDSecureActivity extends FragmentActivity implements ThreeDSDialogListener {
  @Override
  public void onAuthorizationCompleted(String md, String paRes) {
    try {
      JSONObject transactionInfo = new JSONObject();
      transactionInfo.put("TransactionId", md);
      transactionInfo.put("PaRes", paRes);

      CloudpaymentsModule.promise.resolve(transactionInfo.toString());
    } catch(JSONException e) {
      e.printStackTrace();
    } finally {
      finish();
    }
  }

  @Override
  public void onAuthorizationFailed(String html) {
    finish();
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
  }

  @Override
  protected void onStart() {
    super.onStart();
    Intent intent = getIntent();

    //принимаем параметры
    String transactionId = intent.getStringExtra("transactionId");
    String paReq = intent.getStringExtra("paReq");
    String acsUrl = intent.getStringExtra("acsUrl");

    FragmentManager fragmentManager = getSupportFragmentManager();
    ThreeDsDialogFragment.newInstance(acsUrl, transactionId, paReq)
      .show(fragmentManager, "3DS");
  }
}
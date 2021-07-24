package com.reactnativecloudpayments;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.module.annotations.ReactModule;

import com.google.android.gms.tasks.Task;
import com.google.android.gms.wallet.IsReadyToPayRequest;
import com.google.android.gms.wallet.PaymentDataRequest;
import com.google.android.gms.wallet.PaymentData;
import com.google.android.gms.wallet.PaymentsClient;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.wallet.AutoResolveHelper;
import com.google.android.gms.wallet.WalletConstants;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;

import android.app.Activity;
import android.content.Intent;
import androidx.annotation.NonNull;

import java.util.Optional;
import java.lang.String;

@ReactModule(name = GooglePayModule.NAME)
public class GooglePayModule extends ReactContextBaseJavaModule  {
  public static final String NAME = "GooglePay";
  private RequestGooglePay requestGooglePay;
  private int ENVIRONMENT_RUNNING;
  private int REQUEST_CODE = 13; // Arbitrarily-picked constant integer you define to track a request for payment data activity.

  private ActivityEventListener activityEventListener = new BaseActivityEventListener() {
    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
      if (requestCode == REQUEST_CODE) {
        if (resultCode == Activity.RESULT_OK) {
          PaymentData paymentData = PaymentData.getFromIntent(data);
          getSuccessPaymentData(paymentData);
        }
      }
    }
  };

  public GooglePayModule(ReactApplicationContext context) {
    super(context);
    this.requestGooglePay = new RequestGooglePay();
    context.addActivityEventListener(this.activityEventListener);
  }

  private void getSuccessPaymentData (PaymentData paymentData) {
    try {
      EventEmitter eventEmitter = new EventEmitter();
      String paymentInformation = paymentData.toJson();
      JSONObject paymentMethodData = new JSONObject(paymentInformation).getJSONObject("paymentMethodData");
      String token = paymentMethodData.getJSONObject("tokenizationData").getString("token");
      eventEmitter.sendEvent(getReactApplicationContext(), "listenerCryptogramCard", token);
    } catch(JSONException e) {
      e.printStackTrace();
    }
  }

  @ReactMethod
  public void setGatewayTokenSpecification(String gateway, String gatewayMerchantId){
    requestGooglePay.setGatewayTokenSpecification(gateway, gatewayMerchantId);
  }

  @ReactMethod
  public void setPaymentNetworks(ReadableArray listPaymentNetwork) {
    JSONArray paymentNetworks = new JSONArray();
    for (int i = 0; i < listPaymentNetwork.size(); i++) {
      paymentNetworks.put(listPaymentNetwork.getString(i));
    }
    requestGooglePay.setPaymentNetworks(paymentNetworks);
  }


  @ReactMethod
  public void canMakePayments(Promise promise) {
    Activity activity = getCurrentActivity();
    PaymentsClient paymentsClient = requestGooglePay.createPaymentsClient(activity, ENVIRONMENT_RUNNING);
    final Optional<JSONObject> isReadyToPayJson = requestGooglePay.getIsReadyToPayRequest();

    if (!isReadyToPayJson.isPresent()) {
      promise.resolve(false);
      return;
    }

    IsReadyToPayRequest request = IsReadyToPayRequest.fromJson(isReadyToPayJson.get().toString());
    Task<Boolean> task = paymentsClient.isReadyToPay(request);

    task.addOnCompleteListener(activity, new OnCompleteListener<Boolean>() {
      @Override
      public void onComplete(@NonNull Task<Boolean> task) {
        if (task.isSuccessful()) {
          promise.resolve(task.getResult());
        } else {
          promise.resolve(false);
        }
      }
    });
  }

  @ReactMethod
  public void setRequestPay(String countryCode, String currencyCode, String merchantName, String merchantId) {
    requestGooglePay.setRequestPay(countryCode, currencyCode, merchantName, merchantId);
  }

  @ReactMethod
  public void setProducts(ReadableMap product) {
    String price = product.getString("price");
    requestGooglePay.setProducts(price);
  }

  @ReactMethod
  public void setEnvironment(int environmentRunning) {
    this.ENVIRONMENT_RUNNING = environmentRunning;
  }

  @ReactMethod
  public void openGooglePay() {
    Activity activity = getCurrentActivity();
    PaymentsClient paymentsClient = requestGooglePay.createPaymentsClient(activity, ENVIRONMENT_RUNNING);

    String paymentDataRequest = requestGooglePay.getPaymentDataRequest().toString();
    PaymentDataRequest request = PaymentDataRequest.fromJson(paymentDataRequest);

    if (request != null) {
      AutoResolveHelper.resolveTask(paymentsClient.loadPaymentData(request), activity, REQUEST_CODE);
    }
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }
}
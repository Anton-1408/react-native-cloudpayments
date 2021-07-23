package com.reactnativecloudpayments;

import android.app.Activity;

import com.google.android.gms.wallet.PaymentsClient;
import com.google.android.gms.wallet.Wallet;
import com.google.android.gms.wallet.WalletConstants;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Optional;

public class RequestGooglePay {
  private JSONArray paymentNetworks = new JSONArray();
  private JSONObject gatewayTokenSpecification = new JSONObject();
  private JSONArray allowedCardAuthMethods = new JSONArray();
  private JSONObject baseRequest = new JSONObject();
  private JSONObject transactionInfo = new JSONObject();
  private JSONObject merchantInfo = new JSONObject();

  public RequestGooglePay() {
    try {
      this.baseRequest.put("apiVersion", 2);
      this.baseRequest.put("apiVersionMinor", 0);

      this.allowedCardAuthMethods.put("PAN_ONLY");
      this.allowedCardAuthMethods.put("CRYPTOGRAM_3DS");

    } catch (JSONException e) {
      e.printStackTrace();
    }
  }

  public void setGatewayTokenSpecification(String gateway, String gatewayMerchantId){
    try {
      this.gatewayTokenSpecification = new JSONObject(){{
        put("type", "PAYMENT_GATEWAY");
        put("parameters", new JSONObject() {{
          put("gateway", gateway);
          put("gatewayMerchantId", gatewayMerchantId);
        }});
      }};
    } catch (JSONException e) {
      e.printStackTrace();
    }
  }

  public void setPaymentNetworks(JSONArray paymentNetworks) {
    this.paymentNetworks = paymentNetworks;
  }

  private JSONObject getBaseCardPaymentMethod() throws JSONException {
    JSONObject cardPaymentMethod = new JSONObject();
    cardPaymentMethod.put("type", "CARD");

    JSONObject parameters = new JSONObject();
    parameters.put("allowedAuthMethods", this.allowedCardAuthMethods);
    parameters.put("allowedCardNetworks", this.paymentNetworks);

    cardPaymentMethod.put("parameters", parameters);
    return cardPaymentMethod;
  }

  private JSONObject getCardPaymentMethod() throws JSONException {
    JSONObject cardPaymentMethod =  this.getBaseCardPaymentMethod();
    cardPaymentMethod.put("tokenizationSpecification", this.gatewayTokenSpecification);
    return cardPaymentMethod;
  }

  public PaymentsClient createPaymentsClient(Activity activity) {
    Wallet.WalletOptions walletOptions =
      new Wallet.WalletOptions.Builder().setEnvironment(WalletConstants.ENVIRONMENT_TEST).build();
    return Wallet.getPaymentsClient(activity, walletOptions);
  }

  public Optional<JSONObject> getIsReadyToPayRequest() {
    try {
      JSONObject isReadyToPayRequest = this.baseRequest;
      isReadyToPayRequest.put(
        "allowedPaymentMethods", new JSONArray().put(this.getBaseCardPaymentMethod())
      );
      return Optional.of(isReadyToPayRequest);
    } catch (JSONException e) {
      return Optional.empty();
    }
  }

  public void setRequestPay(String countryCode, String currencyCode, String merchantName, String merchantId ) {
    try {
      this.merchantInfo.put("merchantName", merchantName);
      this.merchantInfo.put("merchantId", merchantId);

      this.transactionInfo.put("countryCode", countryCode);
      this.transactionInfo.put("currencyCode", currencyCode);
      this.transactionInfo.put("checkoutOption", "COMPLETE_IMMEDIATE_PURCHASE");
    } catch (JSONException e) {
      e.printStackTrace();
    }
  }

  public void setProducts(String price) {
    try {
      this.transactionInfo.put("totalPrice", price);
      this.transactionInfo.put("totalPriceStatus", "FINAL");
    } catch (JSONException e) {
      e.printStackTrace();
    }
  }

  public JSONObject getPaymentDataRequest() {
    try {
      JSONObject paymentDataRequest = this.baseRequest;
      paymentDataRequest.put(
        "allowedPaymentMethods", new JSONArray().put(this.getCardPaymentMethod())
      );
      paymentDataRequest.put("transactionInfo", this.transactionInfo);
      paymentDataRequest.put("merchantInfo",  this.merchantInfo);
      return paymentDataRequest;
    } catch (JSONException e) {
      return null;
    }
  };
}

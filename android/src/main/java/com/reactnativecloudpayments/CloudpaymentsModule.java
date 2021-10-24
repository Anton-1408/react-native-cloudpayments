package com.reactnativecloudpayments;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.bridge.ReadableMap;

import android.content.Context;
import android.content.Intent;

import org.json.JSONException;
import org.json.JSONObject;

import ru.cloudpayments.sdk.cp_card.CPCard;
import ru.cloudpayments.sdk.cp_card.api.CPCardApi;

@ReactModule(name = CloudpaymentsModule.NAME)
public class CloudpaymentsModule extends ReactContextBaseJavaModule {
  public static final String NAME = "Cloudpayments";
  public static Promise promise;

  public CloudpaymentsModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void isCardNumberValid(String cardNumb, Promise promise) {
    try {
      boolean isCardNumberValid = CPCard.isValidNumber(cardNumb);
      promise.resolve(isCardNumberValid);
    } catch (Exception error) {
      promise.reject("error", error);
    }
  }

  @ReactMethod
  public void isExpDateValid(String cardExpDate, Promise promise) {
    try {
      boolean isExpDateValid = CPCard.isValidExpDate(cardExpDate);
      promise.resolve(isExpDateValid);
    } catch(Exception error) {
      promise.reject("error", error);
    }
  }

  @ReactMethod
  public void cardCryptogramPacket(String cardNumber, String expDate, String cvv, String merchantId, Promise promise) {
    try {
      CPCard card = new CPCard(cardNumber, expDate, cvv);
      String cardCryptogramPacket = card.cardCryptogram(merchantId);
      promise.resolve(cardCryptogramPacket);
    } catch(Exception error) {
      promise.reject("error", error);
    }
  }

  @ReactMethod
  public void cardType(String cardNumber, String expDate, String cvv, Promise promise) {
    try {
      CPCard card = new CPCard(cardNumber, expDate, cvv);
      String typeCard = card.getType();
      promise.resolve(typeCard);
    } catch (Exception error) {
      promise.reject("error", error);
    }
  }

  @ReactMethod
  public void getBinInfo(String cardNumber, Promise promise) {
    try {
      CPCardApi api = new CPCardApi(getCurrentActivity());
      JSONObject bankInfo = new JSONObject();

      api.getBinInfo(cardNumber, binInfo -> {
        try {
          bankInfo.put(
            "logoUrl",
            binInfo.getLogoUrl()
          );
          bankInfo.put(
            "bankName",
            binInfo.getBankName()
          );
          promise.resolve(bankInfo.toString());
        } catch(JSONException error) {
          promise.reject("error", error);
        }
      }, message -> {
          promise.reject("error", message.toString());
      });
    } catch (Exception error) {
      promise.reject("error", error);
    }
  }

  @ReactMethod
  public void requestThreeDSecure(ReadableMap parametres3DS, Promise promise) {
    this.promise = promise;

    String transactionId = parametres3DS.getString("transactionId");
    String paReq = parametres3DS.getString("paReq");
    String acsUrl = parametres3DS.getString("acsUrl");

    Intent intent = new Intent(getCurrentActivity(), ThreeDSecureActivity.class); // действие для запуска нового экрана (из текущего в ThreeDSecureActivity)
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); // добавление флага для создания

    //передаем параметры
    intent.putExtra("transactionId", transactionId);
    intent.putExtra("paReq", paReq);
    intent.putExtra("acsUrl", acsUrl);

    getCurrentActivity().startActivity(intent); // переключаемся на новый экран
  }
}

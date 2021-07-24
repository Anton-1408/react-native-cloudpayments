package com.reactnativecloudpayments;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.bridge.WritableMap;
import androidx.annotation.Nullable;
import com.facebook.react.bridge.ReactContext;
import org.json.JSONObject;

public class EventEmitter {
  public EventEmitter() { }

  public void sendEvent(ReactContext reactContext, String eventName, @Nullable String params) {
    reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
      .emit(eventName, params);
  }
}

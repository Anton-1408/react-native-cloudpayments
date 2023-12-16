package com.reactnativecloudpayments

import com.facebook.react.bridge.ReactContext
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter

class EventEmitter {
  companion object {
    val listenerCryptogramCard = "listenerCryptogramCard"

    fun sendEvent(reactContext: ReactContext, eventName: String?, params: String?) {
      reactContext
        .getJSModule(RCTDeviceEventEmitter::class.java)
        .emit(eventName!!, params)
    }
  }
}

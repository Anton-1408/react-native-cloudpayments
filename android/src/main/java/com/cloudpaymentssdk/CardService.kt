package com.cloudpaymentssdk

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext

import ru.cloudpayments.sdk.card.Card
import ru.cloudpayments.sdk.card.CardType

class CardService(reactContext: ReactApplicationContext): NativeCardServiceSpec(reactContext) {
  companion object {
    const val MODULE_NAME = "CardService"
  }

  override fun getName() = MODULE_NAME;

  override fun cardType(cardNumber: String, promise: Promise?) {
    val cardType = CardType.getType(cardNumber);
    promise?.resolve(cardType.toString());
  }

  override fun isValidNumber(cardNumber: String, promise: Promise?) {
    val isValidNumber = Card.isValidNumber(cardNumber)
    promise?.resolve(isValidNumber)
  }

  override fun isValidExpDate(expDate: String, promise: Promise?) {
    val isValidExpDate = Card.isValidExpDate(expDate)
    promise?.resolve(isValidExpDate)
  }

  override fun createCardCryptogram(
    cardNumber: String,
    cardDate: String,
    cardCVC: String,
    publicId: String,
    publicKey: String,
    promise: Promise?) {
    val cardCryptogram = Card.createCardCryptogram(cardNumber, cardDate, cardCVC, publicId, publicKey)

    if (cardCryptogram != null) {
      promise?.resolve(cardCryptogram)
    } else {
      promise?.reject("error", "cardCryptogram is undefined")
    }
  }

  override fun cardCryptogramForCVV(cvv: String, promise: Promise?) {
    val cvvCryptogramPacket = Card.cardCryptogramForCVV(cvv)

    if (cvvCryptogramPacket != null) {
      promise?.resolve(cvvCryptogramPacket)
    } else {
      promise?.reject("error", "cvvCryptogramPacket is undefined")
    }
  }

  override fun isValidExpDateFull(expDate: String, promise: Promise?) {
    val isValidExpDate = Card.isValidExpDateFull(expDate)
    promise?.resolve(isValidExpDate)
  }

  override fun isValidCvv(cvv: String, promise: Promise?) {
    val isValidCvv = Card.isValidCvv(cvv)
    promise?.resolve(isValidCvv)
  }

  override fun createHexPacketFromData(
    cardNumber: String,
    cardExp: String,
    cardCvv: String,
    publicId: String,
    publicKey: String,
    keyVersion: Double,
    promise: Promise?
  ) {
    val hexPacketFromData = Card.createHexPacketFromData(
      cardNumber,
      cardExp,
      cardCvv,
      publicId,
      publicKey,
      keyVersion.toInt()
    )

    if (hexPacketFromData != null) {
      promise?.resolve(hexPacketFromData)
    } else {
      promise?.reject("error", "hexPacketFromData is undefined")
    }
  }

  override fun createMirPayHexPacketFromCryptogram(
    cryptogram: String,
    promise: Promise?
  ) {
    val mirPayHexPacketFromCryptogram = Card.createMirPayHexPacketFromCryptogram(cryptogram)

    if (mirPayHexPacketFromCryptogram != null) {
      promise?.resolve(mirPayHexPacketFromCryptogram)
    } else {
      promise?.reject("error", "mirPayHexPacketFromCryptogram is undefined")
    }
  }
}

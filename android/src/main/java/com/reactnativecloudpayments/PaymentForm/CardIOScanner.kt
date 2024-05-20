package com.reactnativecloudpayments

import android.content.Context
import android.content.Intent
import android.os.Parcel
import android.os.Parcelable
import io.card.payment.CardIOActivity
import io.card.payment.CreditCard
import ru.cloudpayments.sdk.scanner.CardData
import ru.cloudpayments.sdk.scanner.CardScanner

/*
  * анотация к классу Parcelize - автоматическая генерация реализации класса Parcel
  * реализация абстрактного класса CardScanner, предоставление класса осуществляется в виде массива байтов
  * Это нужно для того востановления состояния экрана
*/

class CardIOScanner : CardScanner(), Parcelable {
  override fun getScannerIntent(context: Context) =
    Intent(context, CardIOActivity::class.java).apply {
      putExtra(CardIOActivity.EXTRA_REQUIRE_EXPIRY, true)
    }

  override fun getCardDataFromIntent(data: Intent) =
    if (data.hasExtra(CardIOActivity.EXTRA_SCAN_RESULT)) {
      val scanResult = data.getParcelableExtra(CardIOActivity.EXTRA_SCAN_RESULT) as? CreditCard
      val month = (scanResult?.expiryMonth ?: 0).toString().padStart(2, '0')
      val yearString = scanResult?.expiryYear?.toString() ?: "00"
      val year = if (yearString.length > 2) {
        yearString.substring(yearString.lastIndex - 1)
      } else {
        yearString.padStart(2, '0')
      }
      val cardData = CardData(scanResult?.cardNumber, month, year, scanResult?.cardholderName)
      cardData
    } else {
      null
    }

  // Parcelable implementation
  override fun writeToParcel(parcel: Parcel, flags: Int) {
    // No properties to write since the class currently has no fields
  }

  override fun describeContents(): Int {
    return 0
  }

  companion object CREATOR : Parcelable.Creator<CardIOScanner> {
    override fun createFromParcel(parcel: Parcel): CardIOScanner {
      return CardIOScanner()
    }

    override fun newArray(size: Int): Array<CardIOScanner?> {
      return arrayOfNulls(size)
    }
  }
}

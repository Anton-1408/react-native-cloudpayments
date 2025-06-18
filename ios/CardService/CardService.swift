import Foundation
import React
import Cloudpayments

@objc(CardServiceSwift)
public class CardServiceSwift: NSObject {
  @objc
  public static let shared = CardServiceSwift()
  
  @objc
  private override init() {
    super.init()
  }
  
  @objc
  public func cardType(_ cardNumber: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    let cardType = Card.cardType(from: cardNumber)
    resolve?(cardType.toString())
  }
  
  @objc
  public func isValidNumber(_ cardNumber: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    let isValidNumber = Card.isCardNumberValid(cardNumber)
    resolve?(isValidNumber)
  }
  
  @objc
  public func isValidExpDate(_ expDate: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    let isValidExpDate = Card.isExpDateValid(expDate)
    resolve?(isValidExpDate)
  }
  
  @objc
  public func createCardCryptogram(
    _ cardNumber: String,
    cardDate: String,
    cardCVC: String,
    publicId: String,
    publicKey: String,
    resolve: RCTPromiseResolveBlock?,
    reject: RCTPromiseRejectBlock?
  ) {
    let publicKeyToInt = Int(publicKey) ?? 0
    
    let cardCryptogramPacket = Card.makeCardCryptogramPacket(cardNumber: cardNumber, expDate: cardDate, cvv: cardCVC, merchantPublicID: publicId, publicKey: publicKey, keyVersion: publicKeyToInt)
    
    if (cardCryptogramPacket != nil) {
      resolve?(cardCryptogramPacket)
    } else {
      reject?("error", "cardCryptogramPacket is undefined", nil);
    }
  }
  
  @objc
  public func cardCryptogramForCVV(
    _ cvv: String,
    resolve: RCTPromiseResolveBlock?,
    reject: RCTPromiseRejectBlock?) {
      let cardCryptogramPacket = Card.makeCardCryptogramPacket(with: cvv)
      
      if (cardCryptogramPacket != nil) {
        resolve?(cardCryptogramPacket)
      } else {
        reject?("error", "cvvCryptogramPacket is undefined", nil);
      }
  }
  
  @objc
  public func isValidExpDateFull(_ expDate: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    reject?("error", "method not yet available", nil);
  }
  
  @objc
  public func isValidCvv(_ cvv: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    let isValidCvv = Card.isValidCvv(cvv: cvv)
    resolve?(isValidCvv)
  }
  
  @objc
  public func createHexPacketFromData(
    _ cardNumber: String,
    cardExp: String,
    cardCvv: String,
    publicId: String,
    publicKey: String,
    keyVersion: Int,
    resolve: RCTPromiseResolveBlock?,
    reject: RCTPromiseRejectBlock?) {
      reject?("error", "method not yet available", nil);
  }
  
  @objc
  public func createMirPayHexPacketFromCryptogram(_ cryptogram: String, resolve: RCTPromiseResolveBlock?, reject: RCTPromiseRejectBlock?) {
    reject?("error", "method not yet available", nil);
  }
}

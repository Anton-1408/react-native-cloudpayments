import Foundation
import React

@objc(CardServiceSwift)
public class CardServiceSwift: NSObject {
  @objc
  public static let shared = CardServiceSwift()
  
  @objc
  private override init() {
    super.init()
  }
  
  @objc
  public func cardType(_ cardNumber: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {}
}

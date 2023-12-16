//
//  ThreeDSecureManager.swift
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 01.02.2022.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation;

@objc(ThreeDSecureManager)
final class ThreeDSecureManager: NSObject {
  @objc var bridge: RCTBridge!

  public static var resolve: RCTPromiseResolveBlock?;
  public static var reject: RCTPromiseRejectBlock?;

  @objc
  public func request(_ parametres3DS: Dictionary<String, String>, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) -> Void {
    ThreeDSecureManager.resolve = resolve;
    ThreeDSecureManager.reject = reject;

    let dataParsed = parseDictionaryToStruct(dictionary: parametres3DS, type: Parametres3DS.self)

    if let requestData = dataParsed {
      let threeDSecureController = ThreeDSecureController();

      threeDSecureController.onShow();
      threeDSecureController.onRequest(
        transactionId: requestData.transactionId,
        paReq: requestData.paReq,
        acsUrl: requestData.acsUrl
      );
    }
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc
  func methodQueue() -> DispatchQueue {
    return .main
  }
}

//
//  EventEmitter.swift
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 01.02.2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation

@objc(EventEmitter)
open class EventEmitter: RCTEventEmitter {
  public static var emitter: RCTEventEmitter!
  private let listenerCryptogramCard = "listenerCryptogramCard"
    
  override init() {
    super.init()
    EventEmitter.emitter = self;
  }

  @objc
  open override func supportedEvents() -> [String] {
      [self.listenerCryptogramCard]
  }

  @objc
  public override static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

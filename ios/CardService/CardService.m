//
//  CardService.swift
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 05.02.2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(CardService, NSObject)
  RCT_EXTERN_METHOD(cardType: (NSString*)cardNumb resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(isCardNumberValid: (NSString*)cardNumb resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(isExpDateValid: (NSString*)cardExpDate resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(makeCardCryptogramPacket: (NSString*)cardNumber expDate: (NSString*)expDate cvv: (NSString*)cvv merchantId: (NSString*)merchantId resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(makeCardCryptogramPacketForCvv: (NSString*)cvv resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(getBinInfo: (NSString*)cardNumber resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
@end

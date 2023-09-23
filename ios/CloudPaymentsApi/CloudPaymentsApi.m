//
//  CloudPaymentsApi.m
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 05.02.2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(CloudPaymentsApi, NSObject)
  RCT_EXTERN_METHOD(initialization: (NSDictionary*)paymentData)
  RCT_EXTERN_METHOD(auth: (NSString*)cardCryptogramPacket email: (NSString*)email resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(charge: (NSString*)cardCryptogramPacket email: (NSString*)email resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(setInformationAboutPaymentOfProduct: (NSDictionary*)details)
@end

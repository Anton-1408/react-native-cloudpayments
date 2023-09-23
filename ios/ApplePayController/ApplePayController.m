//
//  ApplePayController.m
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 06.08.2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(ApplePayController, NSObject)
  RCT_EXTERN_METHOD(open)
  RCT_EXTERN_METHOD(setProducts: (NSArray*)products)
  RCT_EXTERN_METHOD(canMakePayments: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(initialization: (NSDictionary*)methodData)
@end

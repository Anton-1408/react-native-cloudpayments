//
//  ThreeDSecureManager.m
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 01.02.2022.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(ThreeDSecureManager, NSObject)
  RCT_EXTERN_METHOD(request: (NSDictionary*)parametres3DS resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
@end

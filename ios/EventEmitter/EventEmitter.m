//
//  EventEmitter.m
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 01.02.2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(EventEmitter, RCTEventEmitter)
  RCT_EXTERN_METHOD(supportedEvents)
@end

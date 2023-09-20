//
//  PaymentFormManager.m
//  CloudpaymentsSdk
//
//  Created by Anton Votinov on 17.09.2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import "React/RCTViewManager.h"
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(CreditCardFormManager, NSObject)
  RCT_EXTERN_METHOD(initialization: (NSDictionary*)paymentData)
  RCT_EXTERN_METHOD(open: (NSDictionary*)configuration resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(setInformationAboutPaymentOfProduct: (NSDictionary*)details)
@end

#import "React/RCTViewManager.h"
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(CreditCardFormManager, NSObject)
  RCT_EXTERN_METHOD(initial: (NSDictionary*)paymentData)
  RCT_EXTERN_METHOD(open: (NSDictionary*)configuration resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(setDetailsOfPayment: (NSDictionary*)details)
@end

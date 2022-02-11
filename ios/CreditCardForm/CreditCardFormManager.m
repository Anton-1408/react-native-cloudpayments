#import "React/RCTViewManager.h"
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(CreditCardFormManager, NSObject)
  RCT_EXTERN_METHOD(initialPaymentData: (NSDictionary*)paymentData jsonData: (NSDictionary*)jsonData)
  RCT_EXTERN_METHOD(showCreditCardForm: (NSDictionary*)configuration resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
@end

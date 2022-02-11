#import <Foundation/Foundation.h>
#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(ApplePayController, NSObject)
  RCT_EXTERN_METHOD(openApplePay)
  RCT_EXTERN_METHOD(setProducts: (NSArray*)products)
  RCT_EXTERN_METHOD(setRequestPay: (NSString*)countryCode currencyCode: (NSString*)currencyCode merchantId: (NSString*)merchantId)
  RCT_EXTERN_METHOD(canMakePayments: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(setPaymentNetworks: (NSArray*)paymentNetworks)
@end

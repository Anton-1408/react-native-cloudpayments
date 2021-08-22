#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(Cloudpayments, NSObject)
  RCT_EXTERN_METHOD(cardType: (NSString*)cardNumb resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(isCardNumberValid: (NSString*)cardNumb resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(isExpDateValid: (NSString*)cardExpDate resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(cardCryptogramPacket: (NSString*)cardNumber expDate: (NSString*)expDate cvv: (NSString*)cvv merchantId: (NSString*)merchantId resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(getBinInfo: (NSString*)cardNumber resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
@end

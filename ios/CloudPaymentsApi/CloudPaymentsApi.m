#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(CloudPaymentsApi, NSObject)
  RCT_EXTERN_METHOD(initApi: (NSDictionary*)paymentData jsonData: (NSDictionary*)jsonData)
  RCT_EXTERN_METHOD(auth: (NSString*)cardCryptogramPacket email: (NSString*)email resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
  RCT_EXTERN_METHOD(charge: (NSString*)cardCryptogramPacket email: (NSString*)email resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
@end

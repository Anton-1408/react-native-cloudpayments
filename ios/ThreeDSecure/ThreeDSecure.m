#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(ThreeDSecure, NSObject)
  RCT_EXTERN_METHOD(requestThreeDSecure: (NSDictionary*)parametres3DS resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
@end

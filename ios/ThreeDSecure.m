#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(ThreeDSecure, RCTViewManager)
  RCT_EXTERN_METHOD(requestThreeDSecure: (NSDictionary*)parametres3DS resolve: (RCTPromiseResolveBlock)resolve reject: (RCTPromiseRejectBlock)reject)
@end

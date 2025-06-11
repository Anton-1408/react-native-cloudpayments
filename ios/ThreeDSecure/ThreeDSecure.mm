#import "ThreeDSecure.h"
#import "CloudpaymentsSdk-Swift.h"

@implementation ThreeDSecure
RCT_EXPORT_MODULE()

- (void)request:
    (JS::NativeThreeDSecure::RequestParams &)params
    resolve:(RCTPromiseResolveBlock)resolve
    reject:(RCTPromiseRejectBlock)reject {
    NSDictionary *paramsToDictionary =  [self dictionaryFromRequestParams:params];
  
    [[ThreeDSecureSwift shared] request:paramsToDictionary resolve:resolve reject:reject];
}

- (NSDictionary *)dictionaryFromRequestParams:(const JS::NativeThreeDSecure::RequestParams &)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"acsUrl"] = params.acsUrl();
    dict[@"md"] = params.md();
    dict[@"paReq"] = params.paReq();

    return [dict copy];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeThreeDSecureSpecJSI>(params);
}

@end

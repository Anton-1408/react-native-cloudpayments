#import "CloudPaymentsAPI.h"
#import "CloudpaymentsSdk-Swift.h"

@implementation CloudPaymentsApi
RCT_EXPORT_MODULE()

- (void)initialization:
    (NSString *)publicId {
    [[CloudPaymentsAPISwift shared] initialization:publicId];
}

- (void)getBinInfo:
    (NSString *)cardNumber
    resolve:(RCTPromiseResolveBlock)resolve
    reject:(RCTPromiseRejectBlock)reject {
    [[CloudPaymentsAPISwift shared] getBinInfo:cardNumber resolve:resolve reject:reject];
}

- (void)getPublicKey:
    (RCTPromiseResolveBlock)resolve
    reject:(RCTPromiseRejectBlock)reject {
    [[CloudPaymentsAPISwift shared] getPublicKey:resolve reject:reject];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeCloudPaymentsAPISpecJSI>(params);
}

@end

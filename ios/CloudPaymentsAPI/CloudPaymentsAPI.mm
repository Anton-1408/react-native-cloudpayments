#import "CloudPaymentsAPI.h"
#import "CloudpaymentsSdk-Swift.h"

@implementation CloudPaymentsAPI
RCT_EXPORT_MODULE()

- (void)initialization:
    (nonnull NSString *)publicId
    resolve:(RCTPromiseResolveBlock)resolve
    reject:(RCTPromiseRejectBlock)reject {
    [[CloudPaymentsAPISwift shared] initialization:publicId resolve:resolve reject:reject];
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

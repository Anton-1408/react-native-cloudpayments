#import "CardService.h"
#import "CloudpaymentsSdk-Swift.h"

@implementation CardService
RCT_EXPORT_MODULE()

- (void)cardType:
    (NSString *)cardNumber
    resolve:(RCTPromiseResolveBlock)resolve
    reject:(RCTPromiseRejectBlock)reject {

  [[CardServiceSwift shared] cardType:cardNumber resolve:resolve reject:reject];
}


- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeCardServiceSpecJSI>(params);
}

@end

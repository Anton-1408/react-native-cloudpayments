#import "ApplePayModule.h"
#import "CloudpaymentsSdk-Swift.h"

@implementation ServicePay
RCT_EXPORT_MODULE()

- (void)canMakePayments:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject {
  [[ApplePayModuleSwift shared] canMakePayments:resolve reject:reject];
}

- (void)open {
  [[ApplePayModuleSwift shared] open];
}


- (void)initialization:(JS::NativeServicePay::MethodDataPayment &)data { 
  NSDictionary *paramsToDictionary =  [self dictionaryFromRequestParams:data];
  
  [[ApplePayModuleSwift shared] initialization: paramsToDictionary eventEmitter: ^(NSString *cryptogramCard){
    [self emitOnServicePayToken: cryptogramCard];
  }];
}

- (void)setProducts:(nonnull NSArray *)products { 
  [[ApplePayModuleSwift shared] setProducts: products];
}

- (NSDictionary *)dictionaryFromRequestParams:(const JS::NativeServicePay::MethodDataPayment &)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray<NSString *> *networksArray = [NSMutableArray arrayWithCapacity:params.supportedNetworks().size()];

    dict[@"merchantId"] = params.merchantId();
    dict[@"countryCode"] = params.countryCode();
    dict[@"currencyCode"] = params.currencyCode();

    for (const auto &network : params.supportedNetworks()) {
      [networksArray addObject:network];
    }
  
    dict[@"supportedNetworks"] = networksArray;
  
    return [dict copy];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeServicePaySpecJSI>(params);
}

@end


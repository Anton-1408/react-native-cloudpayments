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

-(void)isValidNumber:
  (NSString *)cardNumber
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(RCTPromiseRejectBlock)reject {
  [[CardServiceSwift shared] isValidNumber:cardNumber resolve:resolve reject:reject];
}

-(void)isValidExpDate:
  (NSString *)expDate
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(RCTPromiseRejectBlock)reject {
  [[CardServiceSwift shared] isValidExpDate:expDate resolve:resolve reject:reject];
}

-(void)createCardCryptogram:
  (NSString *)cardNumber
  cardDate:(NSString *)cardDate
  cardCVC: (NSString *)cardCVC
  publicId: (NSString *)publicId
  publicKey: (NSString *)publicKey
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(RCTPromiseRejectBlock)reject{
  [[CardServiceSwift shared]
   createCardCryptogram: cardNumber
   cardDate: cardDate
   cardCVC: cardCVC
   publicId: publicId
   publicKey: publicKey
   resolve: resolve
   reject: reject
  ];
}

-(void)cardCryptogramForCVV:
  (NSString *)cvv
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(RCTPromiseRejectBlock)reject {
  [[CardServiceSwift shared] cardCryptogramForCVV:cvv resolve:resolve reject:reject];
}

-(void)isValidExpDateFull:
  (NSString *)expDate
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(RCTPromiseRejectBlock)reject {
  [[CardServiceSwift shared] isValidExpDateFull:expDate resolve:resolve reject:reject];
}

-(void)isValidCvv:
  (NSString *)cvv
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(RCTPromiseRejectBlock)reject {
  [[CardServiceSwift shared] isValidCvv:cvv resolve:resolve reject:reject];
}

-(void)createHexPacketFromData:
  (NSString *)cardNumber
  cardExp:(NSString *)cardExp
  cardCvv: (NSString *)cardCvv
  publicId: (NSString *)publicId
  publicKey: (NSString *)publicKey
  keyVersion: (NSInteger)keyVersion
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(RCTPromiseRejectBlock)reject {
  [[CardServiceSwift shared]
   createHexPacketFromData: cardNumber
   cardExp: cardExp
   cardCvv: cardCvv
   publicId: publicId
   publicKey: publicKey
   keyVersion: keyVersion
   resolve: resolve
   reject: reject
  ];
}

-(void)createMirPayHexPacketFromCryptogram:
  (NSString *)cryptogram
  resolve:(RCTPromiseResolveBlock)resolve
  reject:(RCTPromiseRejectBlock)reject {
  [[CardServiceSwift shared] createMirPayHexPacketFromCryptogram:cryptogram resolve:resolve reject:reject];
}


- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeCardServiceSpecJSI>(params);
}

@end

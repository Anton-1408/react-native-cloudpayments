#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(CreditCardFormManager, NSObject)
  RCT_EXTERN_METHOD(initialPaymentData: (NSDictionary*)paymentData jsonData: (NSDictionary*)jsonData)
  RCT_EXTERN_METHOD(showCreditCardForm: (NSDictionary*)configuration)
@end

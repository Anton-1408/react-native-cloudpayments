#import "PaymentForm.h"
#import "CloudpaymentsSdk-Swift.h"

@implementation PaymentForm
RCT_EXPORT_MODULE()

- (void)createDataReceipt:(nonnull NSArray *)receiptItems receiptAmounts:(JS::NativePaymentForm::ReceiptAmounts &)receiptAmounts dataPaymentReceipt:(JS::NativePaymentForm::DataPaymentReceipt &)dataPaymentReceipt {
  NSDictionary *receiptAmountsToDictionary =  [self convertReceiptAmountsToDictionary:receiptAmounts];
  NSDictionary *dataPaymentReceiptToDictionary =  [self convertDataPaymentReceiptToDictionary:dataPaymentReceipt];
  
  [[PaymentFormSwift shared] createReceipt: receiptItems receiptAmounts:receiptAmountsToDictionary dataPaymentReceipt: dataPaymentReceiptToDictionary];
}

- (void)createDataRecurrent:(JS::NativePaymentForm::DataRecurrent &)dataRecurrent {
  NSDictionary *paramsToDictionary =  [self convertDataRecurrentToDictionary:dataRecurrent];

  [[PaymentFormSwift shared] createDataRecurrent: paramsToDictionary];
}

- (void)createPayer:(JS::NativePaymentForm::Payer &)payer {
  NSDictionary *paramsToDictionary =  [self convertPayerToDictionary:payer];
  
  [[PaymentFormSwift shared] createPayer: paramsToDictionary];
}

- (void)createPaymentData:(JS::NativePaymentForm::PaymentData &)paymentData {
  NSDictionary *paramsToDictionary =  [self convertDataPaymentToDictionary:paymentData];

  [[PaymentFormSwift shared] createPaymentData: paramsToDictionary];
}

- (void)open:(JS::NativePaymentForm::ConfigurationPaymentForm &)caonfigurationData resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject {
  NSDictionary *paramsToDictionary =  [self convertConfigurationToDictionary:caonfigurationData];
  
  [[PaymentFormSwift shared] open: paramsToDictionary resolve:resolve reject:reject];
}

- (NSDictionary *)convertPayerToDictionary:(const JS::NativePaymentForm::Payer &)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"firstName"] = params.firstName();
    dict[@"lastName"] = params.lastName();
    dict[@"middleName"] = params.middleName();
    dict[@"birthDay"] = params.birthDay();
    dict[@"address"] = params.address();
    dict[@"street"] = params.street();
    dict[@"city"] = params.city();
    dict[@"country"] = params.country();
    dict[@"phone"] = params.phone();
    dict[@"postcode"] = params.postcode();

    return [dict copy];
}

- (NSDictionary *)convertReceiptAmountsToDictionary:(const JS::NativePaymentForm::ReceiptAmounts &)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"credit"] = @(params.credit());
    dict[@"electronic"] = @(params.electronic());
    dict[@"advancePayment"] = @(params.advancePayment());
    dict[@"provision"] = @(params.provision());

    return [dict copy];
}

- (NSDictionary *)convertDataRecurrentToDictionary:(const JS::NativePaymentForm::DataRecurrent &)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"startDate"] = @(params.startDate());
    dict[@"interval"] = params.interval();
    dict[@"period"] = @(params.period());
    dict[@"maxPeriods"] = @(params.maxPeriods());
    dict[@"amount"] = @(params.amount());

    return [dict copy];
}

- (NSDictionary *)convertDataPaymentReceiptToDictionary:(const JS::NativePaymentForm::DataPaymentReceipt &)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"email"] = params.email();
    dict[@"phone"] = params.phone();
    dict[@"taxationSystem"] = @(params.taxationSystem());
    dict[@"isBso"] = @(params.isBso());

    return [dict copy];
}

- (NSDictionary *)convertDataPaymentToDictionary:(const JS::NativePaymentForm::PaymentData &)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"amount"] = params.amount();
    dict[@"currency"] = params.currency();
    dict[@"accountId"] = params.accountId();
    dict[@"description"] = params.description();
    dict[@"email"] = params.email();
    dict[@"applePayMerchantId"] = params.applePayMerchantId();
    dict[@"invoiceId"] = params.invoiceId();
    
    return [dict copy];
}

- (NSDictionary *)convertConfigurationToDictionary:(const JS::NativePaymentForm::ConfigurationPaymentForm &)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"mode"] = params.mode();
    dict[@"publicId"] = params.publicId();
    dict[@"requireEmail"] = @(params.requireEmail());
    dict[@"useDualMessagePayment"] = @(params.useDualMessagePayment());
    dict[@"showResultScreenForSinglePaymentMode"] = @(params.showResultScreenForSinglePaymentMode());
    dict[@"saveCardForSinglePaymentMode"] = @(params.saveCardForSinglePaymentMode());
    dict[@"testMode"] = @(params.testMode());
    dict[@"disableApplePay"] = @(params.disableApplePay());
  
    return [dict copy];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativePaymentFormSpecJSI>(params);
}

@end


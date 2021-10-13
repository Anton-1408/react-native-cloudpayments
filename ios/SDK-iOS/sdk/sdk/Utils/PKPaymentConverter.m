#import "PKPaymentConverter.h"

@interface PKPaymentConverter (Private)
@end

@implementation PKPaymentConverter

+(NSString *) convertToString:(PKPayment *)payment {
    
    NSString *paymentDataString = [[NSString alloc] initWithData:payment.token.paymentData encoding:NSUTF8StringEncoding];
    
    NSDictionary *paymentDataDictionary = [NSJSONSerialization JSONObjectWithData:payment.token.paymentData options:NSJSONReadingMutableContainers error:nil];
    
    NSString *paymentType = @"";
    switch (payment.token.paymentMethod.type) {
        case PKPaymentMethodTypeDebit:
            paymentType = @"debit";
            break;
        case PKPaymentMethodTypeCredit:
            paymentType = @"credit";
            break;
        case PKPaymentMethodTypeStore:
            paymentType = @"store";
            break;
        case PKPaymentMethodTypePrepaid:
            paymentType = @"prepaid";
            break;
        default:
            paymentType = @"unknown";
            break;
    }
    
    NSDictionary *paymentMethodDictionary = @{@"network": payment.token.paymentMethod.network, @"type": paymentType, @"displayName": payment.token.paymentMethod.displayName};

    NSDictionary *cryptogramDictionary = @{@"paymentData": paymentDataDictionary,
                                           @"transactionIdentifier": payment.token.transactionIdentifier,
                                           @"paymentMethod": paymentMethodDictionary
                                           };

    NSDictionary *cardCryptogramPacketDictionary = cryptogramDictionary;

    NSData *cardCryptogramPacketData = [NSJSONSerialization dataWithJSONObject:cardCryptogramPacketDictionary options:0 error:nil];

    NSString *cardCryptogramPacketString = [[NSString alloc] initWithData:cardCryptogramPacketData encoding:NSUTF8StringEncoding];
    
    return cardCryptogramPacketString;
}

@end

#import <PassKit/PassKit.h>

@interface PKPaymentConverter : NSObject {
}

+(NSString *) convertToString: (PKPayment *) payment;

@end

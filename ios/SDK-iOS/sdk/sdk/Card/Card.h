#import <Foundation/Foundation.h>

typedef enum {
    Unknown,
    Visa,
    MasterCard,
    Maestro,
    Mir,
    JCB
} CardType;

@interface Card : NSObject {
    NSMutableArray *keyRefs;
}

+(BOOL) isCardNumberValid: (NSString *) cardNumberString;

+(BOOL) isExpDateValid: (NSString *) expDateString;

+(CardType) cardTypeFromCardNumber:(NSString *)cardNumberString;
+(NSString *) cardTypeToString:(CardType)cardType;

/**
 * Create cryptogram
 *    cardNumberString    valid card number stirng
 *    expDateString         string in format YYMM
 *     CVVString            3-digit number
 *     storePublicID        public_id of store
 */
-(NSString *) makeCardCryptogramPacket: (NSString *) cardNumberString andExpDate: (NSString *) expDateString andCVV: (NSString *) CVVString andMerchantPublicID: (NSString *) merchantPublicIDString;
-(NSString *) makeCardCryptogramPacketForCVV: (NSString *) CVVString andMerchantPublicID: (NSString *) merchantPublicIDString;
@end


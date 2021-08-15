#import "Card.h"
#import "../Utils/NSDataENBase64.h"

#define kPublicKey @"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArBZ1NNjvszen6BNWsgyD\nUJvDUZDtvR4jKNQtEwW1iW7hqJr0TdD8hgTxw3DfH+Hi/7ZjSNdH5EfChvgVW9wt\nTxrvUXCOyJndReq7qNMo94lHpoSIVW82dp4rcDB4kU+q+ekh5rj9Oj6EReCTuXr3\nfoLLBVpH0/z1vtgcCfQzsLlGkSTwgLqASTUsuzfI8viVUbxE1a+600hN0uBh/CYK\noMnCp/EhxV8g7eUmNsWjZyiUrV8AA/5DgZUCB+jqGQT/Dhc8e21tAkQ3qan/jQ5i\n/QYocA/4jW3WQAldMLj0PA36kINEbuDKq8qRh25v+k4qyjb7Xp4W2DywmNtG3Q20\nMQIDAQAB\n-----END PUBLIC KEY-----"
#define kPublicKeyVersion @"04"

@interface Card (Private)
+ (NSString *)cleanCreditCardNo:(NSString *)aCreditCardNo;
@end

@implementation Card

-(id)init
{
    self = [super init];
    if(self) {
        keyRefs = [NSMutableArray array];
        [self addPublicKey:kPublicKey withTag:@"public_key"];
    }
    return self;
}

#pragma mark - Private messages
+ (NSString *)cleanCreditCardNo:(NSString *)aCreditCardNo {
    return [[aCreditCardNo componentsSeparatedByCharactersInSet:
             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
            componentsJoinedByString:@""];
}


// gets public key from const in .pch file
+ (NSData *) getPublicKey {
    NSString *s_key = [NSString string];
    NSArray  *a_key = [kPublicKey componentsSeparatedByString:@"\n"];
    BOOL     f_key  = FALSE;
    
    for (NSString *a_line in a_key) {
        if ([a_line isEqualToString:@"-----BEGIN PUBLIC KEY-----"]) {
            f_key = TRUE;
        }
        else if ([a_line isEqualToString:@"-----END PUBLIC KEY-----"]) {
            f_key = FALSE;
        }
        else if (f_key) {
            s_key = [s_key stringByAppendingString:a_line];
        }
    }
    if (s_key.length == 0) {
        return(FALSE);
    } else {
        
        //        s_key = [s_key stringByAppendingString:@"\n"];
        NSData *returnData = [[NSData alloc] initWithBase64EncodedString:s_key options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        returnData = [Card stripPublicKeyHeader:returnData];
        
        
        return returnData;
    }
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key
{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx    = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

-(NSString *) makeCardCryptogramPacket: (NSString *) cardNumberString andExpDate: (NSString *) expDateString andCVV: (NSString *) CVVString andMerchantPublicID: (NSString *) merchantPublicIDString {
    
    // ExpDate must be in YYMM format
    NSArray *cardDateComponents = [expDateString componentsSeparatedByString:@"/"];
    NSString *cardExpirationDateString = [NSString stringWithFormat:@"%@%@",cardDateComponents[1],cardDateComponents[0]];
    
    NSMutableString *packetString = [NSMutableString string];
    NSString *cryptogramString = nil;
    NSString *decryptedCryptogram = nil;
    
    // create cryptogram
    NSString *cleanCardNumber = [Card cleanCreditCardNo:cardNumberString];
    decryptedCryptogram = [NSString stringWithFormat:@"%@@%@@%@@%@",
                           cleanCardNumber,
                           cardExpirationDateString,
                           CVVString,
                           merchantPublicIDString];
    
    SecKeyRef key = [self publicKey];
    cryptogramString = [Card encryptRSA:decryptedCryptogram key:key padding:kSecPaddingOAEP];
    cryptogramString = [cryptogramString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cryptogramString = [cryptogramString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    [packetString appendString:@"02"];
    [packetString appendString:[cleanCardNumber substringWithRange:NSMakeRange(0, 6)]];
    [packetString appendString:[cleanCardNumber substringWithRange:NSMakeRange(cleanCardNumber.length-4, 4)]];
    [packetString appendString:cardExpirationDateString];
    [packetString appendString:kPublicKeyVersion];
    [packetString appendString:cryptogramString];
    
    return (NSString *) packetString;
}

-(NSString *) makeCardCryptogramPacketForCVV: (NSString *) CVVString andMerchantPublicID: (NSString *) merchantPublicIDString {
    NSMutableString *packetString = [NSMutableString string];
    
    SecKeyRef key = [self publicKey];
    NSString* cryptogramString = [Card encryptRSA:CVVString key:key padding:kSecPaddingPKCS1];
    cryptogramString = [cryptogramString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cryptogramString = [cryptogramString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    [packetString appendString:@"03"];
    [packetString appendString:kPublicKeyVersion];
    [packetString appendString:cryptogramString];
    
    return (NSString *) packetString;
}

#pragma mark - Public messages
+(BOOL) isCardNumberValid: (NSString *) cardNumberString {
    NSString *cleanCardNumber = [Card cleanCreditCardNo:cardNumberString];
    
    if (cleanCardNumber.length == 0) {
        return NO;
    }
    
    NSMutableArray *cardNumberCharactersArray = [[NSMutableArray alloc] initWithCapacity:[cleanCardNumber length]];
    for (int i=0; i < [cleanCardNumber length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [cleanCardNumber characterAtIndex:i]];
        [cardNumberCharactersArray addObject:ichar];
    }
    
    // INFO: one of Luhn algorithm implementation
    BOOL isOdd = YES;
    int oddSum = 0;
    int evenSum = 0;
    
    for (int i = (int)[cleanCardNumber length] - 1; i >= 0; i--) {
        int digit = [(NSString *)[cardNumberCharactersArray objectAtIndex:i] intValue];
        if (isOdd) {
            oddSum += digit;
        } else {
            evenSum += digit/5 + (2*digit) % 10;
        }
        
        isOdd = !isOdd;
    }
    
    return ((oddSum + evenSum) % 10 == 0);
}

+ (BOOL)isExpDateValid:(NSString *)expDateString {
    
    if (expDateString.length != 5) {
        return false;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/yy"];
    NSDate *date = [dateFormatter dateFromString:expDateString];
    
    // get last day of the current month
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];

    NSRange dayRange = [ calendar rangeOfUnit:NSCalendarUnitDay
                                       inUnit:NSCalendarUnitMonth
                                      forDate:date];

    NSInteger numberOfDaysInCurrentMonth = dayRange.length;

    NSDateComponents *comp = [calendar components:
                              NSCalendarUnitYear |
                              NSCalendarUnitMonth |
                              NSCalendarUnitDay fromDate:date];

    comp.day = numberOfDaysInCurrentMonth;
    comp.hour = 24;
    comp.minute = 0;
    comp.second = 0;

    date = [calendar dateFromComponents:comp];
    
    NSDate *now = [NSDate new];
    
    if([date compare: now] == NSOrderedDescending){
        return true;
    }
    
    return false;
}

+(CardType) cardTypeFromCardNumber:(NSString *)cardNumberString {
    NSString *cleanCardNumber = [Card cleanCreditCardNo:cardNumberString];
    
    if (cleanCardNumber.length < 1) {
        return Unknown;
    }
    
    int first = [[cleanCardNumber substringWithRange:NSMakeRange(0, 1)] intValue];
    
    if (first == 4) {
        return Visa;
    }
    
    if (first == 6) {
        return Maestro;
    }
    
    if (cleanCardNumber.length < 2) {
        return Unknown;
    }
    
    int firstTwo = [[cleanCardNumber substringWithRange:NSMakeRange(0, 2)] intValue];
    
    if (firstTwo == 35) {
        return JCB;
    }
    
    if (firstTwo == 50 || (firstTwo >= 56 && firstTwo <= 58)) {
        return Maestro;
    }
    
    if (firstTwo >= 51 && firstTwo <= 55) {
        return MasterCard;
    }
    
    if (cleanCardNumber.length < 4) {
        return Unknown;
    }
    
    int firstFour = [[cleanCardNumber substringWithRange:NSMakeRange(0, 4)] intValue];
   
    if (firstFour >= 2200 && firstFour <= 2204) {
        return Mir;
    }
    
    if (firstFour >= 2221 && firstFour <= 2720) {
        return MasterCard;
    }
    
    return Unknown;
}

+(NSString *) cardTypeToString:(CardType)cardType {
    
    switch(cardType) {
        case Visa:
            return @"Visa";
            break;
        case MasterCard:
            return @"MasterCard";
            break;
        case Maestro:
            return @"Maestro";
            break;
        case Mir:
            return @"MIR";
            break;
        case JCB:
            return @"JCB";
            break;
        default:
            return @"Unknown";
    }
}

#pragma mark - Security
+(NSString *)encryptRSA:(NSString *)plainTextString key:(SecKeyRef)publicKey padding:(SecPadding)padding
{
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize);
    uint8_t *nonce = (uint8_t *)[plainTextString cStringUsingEncoding:NSASCIIStringEncoding];
    SecKeyEncrypt(publicKey,
                  padding,
                  nonce,
                  strlen( (char*)nonce ),
                  &cipherBuffer[0],
                  &cipherBufferSize);
    NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    return [NSDataENBase64 base64StringFromData:encryptedData];
}

+(NSString *)decryptRSA:(NSString *)cipherString key:(SecKeyRef) privateKey {
    size_t plainBufferSize = SecKeyGetBlockSize(privateKey);
    uint8_t *plainBuffer = malloc(plainBufferSize);
    NSData *incomingData = [NSDataENBase64 dataFromBase64String:cipherString];
    uint8_t *cipherBuffer = (uint8_t*)[incomingData bytes];
    size_t cipherBufferSize = SecKeyGetBlockSize(privateKey);
    SecKeyDecrypt(privateKey,
                  kSecPaddingOAEP,
                  cipherBuffer,
                  cipherBufferSize,
                  plainBuffer,
                  &plainBufferSize);
    NSData *decryptedData = [NSData dataWithBytes:plainBuffer length:plainBufferSize];
    NSString *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSASCIIStringEncoding];
    return decryptedString;
}

-(SecKeyRef)publicKey
{
    SecKeyRef p_key = NULL;
    for (NSValue *refVal in keyRefs) {
        [refVal getValue:&p_key];
        if (p_key == NULL) continue;
    }
    return p_key;
}

- (NSData *)stripPublicKeyHeader:(NSData *)d_key
{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx    = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

- (BOOL)addPublicKey:(NSString *)key withTag:(NSString *)tag
{
    NSString *s_key = [NSString string];
    NSArray  *a_key = [key componentsSeparatedByString:@"\n"];
    BOOL     f_key  = FALSE;
    
    for (NSString *a_line in a_key) {
        if ([a_line isEqualToString:@"-----BEGIN PUBLIC KEY-----"]) {
            f_key = TRUE;
        }
        else if ([a_line isEqualToString:@"-----END PUBLIC KEY-----"]) {
            f_key = FALSE;
        }
        else if (f_key) {
            s_key = [s_key stringByAppendingString:a_line];
        }
    }
    if (s_key.length == 0) return(FALSE);
    
    // This will be base64 encoded, decode it.
    NSData *d_key = [NSDataENBase64 dataFromBase64String:s_key];
    d_key = [self stripPublicKeyHeader:d_key];
    if (d_key == nil) return(FALSE);
    
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    CFTypeRef persistKey = nil;
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:d_key forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    OSStatus secStatus = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil) CFRelease(persistKey);
    
    if ((secStatus != noErr) && (secStatus != errSecDuplicateItem)) {
        return(FALSE);
    }
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef
     ];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    secStatus = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey,
                                    (CFTypeRef *)&keyRef);
    
    if (keyRef == nil) return(FALSE);
    
    // Add to our pseudo keychain
    [keyRefs addObject:[NSValue valueWithBytes:&keyRef objCType:@encode(
                                                                        SecKeyRef)]];
    
    return(TRUE);
}

@end

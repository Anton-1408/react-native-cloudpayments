//
//  NSData+ENBase64.h
//  base64
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSDataENBase64: NSData

+ (NSData *)dataFromBase64String:(NSString *)aString;
+ (NSString *)base64StringFromData: (NSData *)aData;

- (NSString *)base64EncodedString;

@end


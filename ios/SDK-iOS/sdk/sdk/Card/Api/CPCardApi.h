#import <Foundation/Foundation.h>

@class BinInfo;

@protocol CPCardApiDelegate
@required
- (void) didFinishBinInfo: (BinInfo *)info;
- (void) didFailWithError: (NSString *)message;
@end

@interface CPCardApi : NSObject;
@property (weak, nonatomic) id<CPCardApiDelegate> delegate;
 - (void) getBinInfo: (NSString *)firstSixDigits;
@end

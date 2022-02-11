#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(EventEmitter, RCTEventEmitter)
  RCT_EXTERN_METHOD(supportedEvents)
@end

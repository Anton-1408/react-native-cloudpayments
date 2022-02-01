#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(EventEmitter, RCTEventEmitter)
  RCT_EXTERN_METHOD(supportedEvents)
@end

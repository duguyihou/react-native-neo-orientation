#import "React/RCTBridgeModule.h"

@interface

RCT_EXTERN_MODULE(NeoOrientation, NSObject)

RCT_EXTERN_METHOD(lockToLandscape)
RCT_EXTERN_METHOD(lockToPortrait)
RCT_EXTERN_METHOD(lockToPortraitUpsideDown)
RCT_EXTERN_METHOD(lockToLandscapeRight)
RCT_EXTERN_METHOD(lockToLandscapeLeft)
RCT_EXTERN_METHOD(unlockAllOrientations)

@end
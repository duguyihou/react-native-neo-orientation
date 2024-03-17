#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface NeoOrientation : RCTEventEmitter <RCTBridgeModule>
+ (UIInterfaceOrientationMask)getOrientationMask;
@end

//
//  NeoOrientation.h
//  NeoOrientation
//
//  Created by Kong Hou on 20/7/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface NeoOrientation : RCTEventEmitter <RCTBridgeModule>
+ (void)setOrientation: (UIInterfaceOrientationMask)orientation;
+ (UIInterfaceOrientationMask)getOrientation;
@end

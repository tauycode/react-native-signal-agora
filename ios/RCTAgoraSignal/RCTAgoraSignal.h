//
//  RCTAgoraSignal.h
//  RCTAgoraSignal
//
//  Created by Tauy on 2019/1/25.
//  Copyright © 2019 ylibs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import <AgoraSigKit/AgoraSigKit.h>

@interface RCTAgoraSignal : NSObject<RCTBridgeModule>

@property (nonatomic, copy) NSString *appid;

@end

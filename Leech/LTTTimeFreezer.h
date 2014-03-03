//
//  LTTTimeFreezer.h
//  Leech
//
//  Created by Sam Odom on 3/2/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTTimeFreezer : NSObject

+ (void)freezeTime;
+ (void)unfreezeTime;
+ (BOOL)timeIsFrozen;
+ (void)setFrozenDate:(NSDate*)newDate;

@end

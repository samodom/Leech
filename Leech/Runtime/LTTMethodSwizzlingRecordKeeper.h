//
//  LTTMethodSwizzlingRecordKeeper.h
//  Leech
//
//  Created by Sam Odom on 2/16/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTTMethodSwizzlingRecord;

@interface LTTMethodSwizzlingRecordKeeper : NSObject


- (BOOL)isClassMethodSwizzledForSelector:(SEL)realSelector;
- (BOOL)isInstanceMethodSwizzledForSelector:(SEL)realSelector;

- (BOOL)acceptMethodSwizzlingRecord:(LTTMethodSwizzlingRecord*)record;
- (void)releaseMethodSwizzlingRecord:(LTTMethodSwizzlingRecord*)record;


@end

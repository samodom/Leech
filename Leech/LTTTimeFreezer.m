//
//  LTTTimeFreezer.m
//  Leech
//
//  Created by Sam Odom on 3/2/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <objc/runtime.h>

#import "LTTTimeFreezer.h"
#import "LTTMethodSwizzler.h"

const char *LTTTimeFreezerFrozenDateKey = "LTTTimeFreezerFrozenDateKey";

@implementation NSDate (TimeFreezer)

+ (void)swizzleDateMethods {
    [LTTMethodSwizzler swapClassMethodsForClass:[self class] selectorOne:@selector(date) selectorTwo:@selector(TimeFreezer_Date)];
}

+ (instancetype)TimeFreezer_Date {
    return objc_getAssociatedObject([self class], LTTTimeFreezerFrozenDateKey);
}

@end

@implementation LTTTimeFreezer

+ (void)freezeTime {
    NSAssert(objc_getAssociatedObject(self, LTTTimeFreezerFrozenDateKey) == nil, @"Freezing time when it's already frozen is a programming error");
    @synchronized([NSDate class]) {
        NSDate *date = [NSDate date];
        [NSDate swizzleDateMethods];
        objc_setAssociatedObject([NSDate class], LTTTimeFreezerFrozenDateKey, date, OBJC_ASSOCIATION_RETAIN);
    }
}

+ (void)unfreezeTime {
    NSAssert(objc_getAssociatedObject([NSDate class], LTTTimeFreezerFrozenDateKey) != nil, @"Unfreezing time when it's not frozen is a programming error");
    @synchronized([NSDate class]) {
        [NSDate swizzleDateMethods];
        objc_setAssociatedObject([NSDate class], LTTTimeFreezerFrozenDateKey, nil, OBJC_ASSOCIATION_ASSIGN);
    }
}

+ (BOOL)timeIsFrozen {
    return objc_getAssociatedObject([NSDate class], LTTTimeFreezerFrozenDateKey) != nil;
}

+ (void)setFrozenDate:(NSDate *)newDate {
    objc_setAssociatedObject([NSDate class], LTTTimeFreezerFrozenDateKey, newDate, OBJC_ASSOCIATION_RETAIN);
}

@end

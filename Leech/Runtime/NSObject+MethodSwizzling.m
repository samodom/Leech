//
//  NSObject+MethodSwizzling.m
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+MethodSwizzling.h"

#import "LTTClassMethodSwizzlingRecord.h"
#import "LTTInstanceMethodSwizzlingRecord.h"


@implementation NSObject (MethodSwizzling)


- (void)swizzleMethodWithRecord:(LTTMethodSwizzlingRecord *)methodSwizzlingRecord {
//    if (
    [[self class] swapMethodImplementations:methodSwizzlingRecord];
}

- (void)unswizzleMethodWithRecord:(LTTMethodSwizzlingRecord *)methodSwizzlingRecord {
    [[self class] swapMethodImplementations:methodSwizzlingRecord];
}

+ (void)swapMethodImplementations:(LTTMethodSwizzlingRecord*)methodSwizzlingRecord {
    Method realMethod, fakeMethod;
    SEL realSelector = methodSwizzlingRecord.realSelector;
    SEL fakeSelector = methodSwizzlingRecord.fakeSelector;
    Class class = [self class];

    if ([methodSwizzlingRecord isKindOfClass:[LTTClassMethodSwizzlingRecord class]]) {
        realMethod = class_getClassMethod(class, realSelector);
        fakeMethod = class_getClassMethod(class, fakeSelector);
    }
    else {
        realMethod = class_getInstanceMethod(class, realSelector);
        fakeMethod = class_getInstanceMethod(class, fakeSelector);
    }

    method_exchangeImplementations(realMethod, fakeMethod);
}


@end

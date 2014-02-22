//
//  LTTMethodSwizzler.m
//  Leech
//
//  Created by Sam Odom on 2/22/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <objc/runtime.h>

#import "LTTMethodSwizzler.h"

@implementation LTTMethodSwizzler

+ (void)swapClassMethodsForClass:(Class)cls selectorOne:(SEL)selectorOne selectorTwo:(SEL)selectorTwo {
    Method method1 = class_getClassMethod(cls, selectorOne);
    Method method2 = class_getClassMethod(cls, selectorTwo);
    method_exchangeImplementations(method1, method2);
}

+ (void)swapInstanceMethodsForClass:(Class)cls selectorOne:(SEL)selectorOne selectorTwo:(SEL)selectorTwo {
    Method method1 = class_getInstanceMethod(cls, selectorOne);
    Method method2 = class_getInstanceMethod(cls, selectorTwo);
    method_exchangeImplementations(method1, method2);
}

@end

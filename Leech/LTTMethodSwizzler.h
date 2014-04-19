//
//  LTTMethodSwizzler.h
//  Leech
//
//  Created by Sam Odom on 2/22/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Helper class for swizzling methods on a class
 */
@interface LTTMethodSwizzler : NSObject

/**
 Swaps the implementations of two class methods on a given class
 */
+ (void) swapClassMethodsForClass:(Class)cls selectorOne:(SEL)selectorOne selectorTwo:(SEL)selectorTwo;

/**
 Swaps the implementations of two instance methods on a given class
 */
+ (void) swapInstanceMethodsForClass:(Class)cls selectorOne:(SEL)selectorOne selectorTwo:(SEL)selectorTwo;

@end

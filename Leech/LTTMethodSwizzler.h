//
//  LTTMethodSwizzler.h
//  Leech
//
//  Created by Sam Odom on 2/22/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTMethodSwizzler : NSObject

+ (void) swapClassMethodsForClass:(Class)cls selectorOne:(SEL)selectorOne selectorTwo:(SEL)selectorTwo;

+ (void) swapInstanceMethodsForClass:(Class)cls selectorOne:(SEL)selectorOne selectorTwo:(SEL)selectorTwo;

@end

//
//  NSObject+MethodSwizzling.h
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTTMethodSwizzlingRecord;

@interface NSObject (MethodSwizzling)

- (void)swizzleMethodWithRecord:(LTTMethodSwizzlingRecord*)methodSwizzlingRecord;
- (void)unswizzleMethodWithRecord:(LTTMethodSwizzlingRecord*)methodSwizzlingRecord;

@end

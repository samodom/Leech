//
//  SampleSwizzlableClass.h
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SampleSwizzlableClass : NSObject


#pragma mark Class

+ (void)realClassMethod;
+ (void)fakeClassMethod;

+ (BOOL)realClassMethodCalled;
+ (BOOL)fakeClassMethodCalled;
+ (void)clearClassMethodCallFlags;


#pragma mark Instance

@property BOOL realInstanceMethodCalled;
@property BOOL fakeInstanceMethodCalled;

- (void)realInstanceMethod;
- (void)fakeInstanceMethod;


@end

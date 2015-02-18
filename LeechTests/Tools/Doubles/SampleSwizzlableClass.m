//
//  SampleSwizzlableClass.m
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import "SampleSwizzlableClass.h"

#import "NSObject+ObjectAssociation.h"

const char * RealSampleClassMethodCalled = "RealSampleClassMethodCalled";
const char * FakeSampleClassMethodCalled = "FakeSampleClassMethodCalled";

@implementation SampleSwizzlableClass


#pragma mark Class

+ (void)realClassMethod {
    [[self class] associateKey:RealSampleClassMethodCalled withObject:@YES];
}

+ (void)fakeClassMethod {
    [[self class] associateKey:FakeSampleClassMethodCalled withObject:@YES];
}

+ (BOOL)realClassMethodCalled {
    NSNumber *methodCalled = [[self class] associationForKey:RealSampleClassMethodCalled];
    return methodCalled.boolValue;
}

+ (BOOL)fakeClassMethodCalled {
    NSNumber *methodCalled = [[self class] associationForKey:FakeSampleClassMethodCalled];
    return methodCalled.boolValue;
}

+ (void)clearClassMethodCallFlags {
    [[self class] clearAssociationForKey:RealSampleClassMethodCalled];
    [[self class] clearAssociationForKey:FakeSampleClassMethodCalled];
}


#pragma mark Instance

- (void)realInstanceMethod {
    self.realInstanceMethodCalled = YES;
}

- (void)fakeInstanceMethod {
    self.fakeInstanceMethodCalled = YES;
}


@end

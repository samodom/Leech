//
//  MethodSwizzlingRecordTests.m
//  Leech
//
//  Created by Sam Odom on 2/14/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LTTMethodSwizzlingRecord.h"
#import "LTTClassMethodSwizzlingRecord.h"
#import "LTTInstanceMethodSwizzlingRecord.h"

#import "SampleSwizzlableClass.h"

@interface MethodSwizzlingRecordTests : XCTestCase

@end

@implementation MethodSwizzlingRecordTests {
    LTTMethodSwizzlingRecord *classRecord, *instanceRecord;
    SampleSwizzlableClass *object;
    SEL realClassSelector, fakeClassSelector;
    SEL realInstanceSelector, fakeInstanceSelector;
}

- (void)setUp {
    [super setUp];

    realClassSelector = @selector(realClassMethod);
    fakeClassSelector = @selector(fakeClassMethod);
    realInstanceSelector = @selector(realInstanceMethod);
    fakeInstanceSelector = @selector(fakeInstanceMethod);

    classRecord = [LTTMethodSwizzlingRecord classRecordWithRealSelector:realClassSelector
                                                           fakeSelector:fakeClassSelector];
    instanceRecord = [LTTMethodSwizzlingRecord instanceRecordWithRealSelector:realInstanceSelector
                                                                 fakeSelector:fakeInstanceSelector];
}

- (void)tearDown {
    object = nil;
    realClassSelector = nil;
    fakeClassSelector = nil;
    realInstanceSelector = nil;
    fakeInstanceSelector = nil;

    classRecord = nil;
    instanceRecord = nil;

    [super tearDown];
}

- (void)testClassRecordFactoryMethod {
    XCTAssertTrue([classRecord isKindOfClass:[LTTClassMethodSwizzlingRecord class]], @"The record superclass should provide class method swizzling records");
}

- (void)testClassRecordHasRealSelector {
    XCTAssertEqual(classRecord.realSelector, realClassSelector, @"The record should keep track of the real selector");
}

- (void)testClassRecordHasFakeSelector {
    XCTAssertEqual(classRecord.fakeSelector, fakeClassSelector, @"The record should keep track of the fake selector");
}

- (void)testInstanceRecordFactoryMethod {
    XCTAssertTrue([instanceRecord isKindOfClass:[LTTInstanceMethodSwizzlingRecord class]], @"The record superclass should provide instance method swizzling records");
}

- (void)testInstanceRecordHasRealSelector {
    XCTAssertEqual(instanceRecord.realSelector, realInstanceSelector, @"The record should keep track of the real selector");
}

- (void)testInstanceRecordHasFakeSelector {
    XCTAssertEqual(instanceRecord.fakeSelector, fakeInstanceSelector, @"The record should keep track of the fake selector");
}


@end

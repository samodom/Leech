//
//  ObjectAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 4/1/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTObjectAuditor.h"

@interface SampleObject : NSObject

- (id)sampleMethod:(id)input;

@end

@implementation SampleObject

- (id)sampleMethod:(id)input {
    return input;
}

@end

@interface ObjectAuditorTests : XCTestCase

@end

@implementation ObjectAuditorTests {
    SampleObject *auditedObject, *argument;
}

- (void)setUp {
    [super setUp];

    auditedObject = [SampleObject new];
    argument = [SampleObject new];
}

- (void)tearDown {
    argument = nil;
    auditedObject = nil;

    [super tearDown];
}

- (void)testAuditingOfPerformSelectorOnMainThreadMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([auditedObject class], @selector(performSelectorOnMainThread:withObject:waitUntilDone:)));
    [LTTObjectAuditor auditPerformSelectorOrMainThreadMethod:auditedObject];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([auditedObject class], @selector(performSelectorOnMainThread:withObject:waitUntilDone:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [auditedObject performSelectorOnMainThread:@selector(sampleMethod:) withObject:argument waitUntilDone:YES];
    SEL selector = [LTTObjectAuditor selectorToPerform:auditedObject];
    XCTAssertEqual(selector, @selector(sampleMethod:), @"The selector to perform should be captured");
    id arg = [LTTObjectAuditor argumentToSelector:auditedObject];
    XCTAssertEqualObjects(arg, argument, @"The argument to the selector should be captured");
    XCTAssertEqualObjects([auditedObject performSelector:selector withObject:arg], argument, @"The method should work with the audited values");
    XCTAssertTrue([LTTObjectAuditor waitUntilDoneFlag:auditedObject], @"The wait until done flag should be captured");
    [LTTObjectAuditor stopAuditingPerformSelectorOnMainThreadMethod:auditedObject];
    currentImplementation = method_getImplementation(class_getInstanceMethod([auditedObject class], @selector(performSelectorOnMainThread:withObject:waitUntilDone:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end

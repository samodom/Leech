//
//  CoreDataAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 3/4/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

//  Mocks+


//  Production
#import "LTTCoreDataAuditor.h"

@interface CoreDataAuditorTests : XCTestCase

@end

@implementation CoreDataAuditorTests {
    NSManagedObjectContext *context;
    core_data_perform_t blockToPerform;
}

- (void)setUp {
    [super setUp];

    context = [NSManagedObjectContext new];
}

- (void)tearDown {
    blockToPerform = nil;
    context = nil;

    [super tearDown];
}

#pragma mark -performBlock:

- (void) testAuditingPerformBlockSwizzlesMethods {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlock:)));
    [LTTCoreDataAuditor auditPerformBlock];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlock:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [LTTCoreDataAuditor stopAuditingPerformBlock];
    currentImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlock:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingPerformBlockCapturesBlock {
    __block BOOL blockPerformed = NO;
    blockToPerform = ^ {
        blockPerformed = YES;
    };
    [LTTCoreDataAuditor auditPerformBlock];
    [context performBlock:blockToPerform];
    core_data_perform_t capturedBlock = [LTTCoreDataAuditor blockToPerform];
    XCTAssertEqualObjects(capturedBlock, blockToPerform, @"The block to perform should be captured");
    XCTAssertFalse(blockPerformed, @"The block should not have been performed");
    capturedBlock();
    XCTAssertTrue(blockPerformed, @"The block should have been performed now");
    [LTTCoreDataAuditor stopAuditingPerformBlock];
}

#pragma mark -performBlockAndWait:

- (void) testAuditingPerformBlockAndWaitSwizzlesMethods {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlockAndWait:)));
    [LTTCoreDataAuditor auditPerformBlockAndWait];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlockAndWait:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [LTTCoreDataAuditor stopAuditingPerformBlockAndWait];
    currentImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlockAndWait:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingPerformBlockAndWaitCapturesBlock {
    __block BOOL blockPerformed = NO;
    blockToPerform = ^ {
        blockPerformed = YES;
    };
    [LTTCoreDataAuditor auditPerformBlockAndWait];
    [context performBlockAndWait:blockToPerform];
    core_data_perform_t capturedBlock = [LTTCoreDataAuditor blockToPerform];
    XCTAssertEqualObjects(capturedBlock, blockToPerform, @"The block to perform should be captured");
    XCTAssertFalse(blockPerformed, @"The block should not have been performed");
    capturedBlock();
    XCTAssertTrue(blockPerformed, @"The block should have been performed now");
    [LTTCoreDataAuditor stopAuditingPerformBlockAndWait];
}

@end

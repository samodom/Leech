//
//  CoreDataAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 3/4/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTCoreDataAuditor.h"

@interface CoreDataAuditorTests : XCTestCase

@end

@implementation CoreDataAuditorTests {
    NSManagedObjectContext *context;
    core_data_perform_t blockToPerform;
    core_data_perform_t multiBlockOne, multiBlockTwo, multiBlockThree;
}

- (void)setUp {
    [super setUp];

    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
}

- (void)tearDown {
    blockToPerform = nil;
    multiBlockOne = nil;
    multiBlockTwo = nil;
    multiBlockThree = nil;
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

- (void)testAuditingOfNestedPerformBlock {
    __block BOOL otherBlockPerformed = NO;
    core_data_perform_t otherBlockToPerform = ^{
        otherBlockPerformed = YES;
    };
    
    __block BOOL blockPerformed = NO;
    __block __weak NSManagedObjectContext *weakContext = context;
    blockToPerform = ^{
        blockPerformed = YES;
        [weakContext performBlock:otherBlockToPerform];
    };
    
    [LTTCoreDataAuditor auditPerformBlock];
    [context performBlock:blockToPerform];
    core_data_perform_t capturedBlock = [LTTCoreDataAuditor blockToPerform];
    XCTAssertEqualObjects(capturedBlock, blockToPerform, @"The block to perform should be captured");
    XCTAssertFalse(blockPerformed, @"The block should not have been performed");
    [LTTCoreDataAuditor stopAuditingPerformBlock];
    [LTTCoreDataAuditor auditPerformBlock];
    capturedBlock();
    core_data_perform_t otherCapturedBlock = [LTTCoreDataAuditor blockToPerform];
    XCTAssertEqualObjects(otherCapturedBlock, otherBlockToPerform, @"The second block to perform should be captured");
    XCTAssertFalse(otherBlockPerformed, @"The block should not have been performed");
    otherCapturedBlock();
    XCTAssertTrue(otherBlockPerformed, @"The block should have been performed now");
    [LTTCoreDataAuditor stopAuditingPerformBlock];
}

- (void) testAuditingPerformMultipleBlocksSwizzlesMethods {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlock:)));
    [LTTCoreDataAuditor auditPerformMultipleBlocks];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlock:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [LTTCoreDataAuditor stopAuditingPerformMultipleBlocks];
    currentImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlock:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingPerformMultipleBlocksCapturesBlocks {
    __block BOOL blockOnePerformed = NO;
    multiBlockOne = ^ {
        blockOnePerformed = YES;
    };
    __block BOOL blockTwoPerformed = NO;
    multiBlockTwo = ^ {
        blockTwoPerformed = YES;
    };
    __block BOOL blockThreePerformed = NO;
    multiBlockThree = ^ {
        blockThreePerformed = YES;
    };
    [LTTCoreDataAuditor auditPerformMultipleBlocks];
    [context performBlock:multiBlockOne];
    [context performBlock:multiBlockTwo];
    [context performBlock:multiBlockThree];
    NSArray *capturedBlocks = [LTTCoreDataAuditor blocksToPerform];
    XCTAssertEqual(capturedBlocks.count, (NSUInteger)3, @"There should be three blocks captured");
    XCTAssertFalse(blockOnePerformed, @"The first block should not have been performed");
    XCTAssertFalse(blockTwoPerformed, @"The second block should not have been performed");
    XCTAssertFalse(blockThreePerformed, @"The third block should not have been performed");
    core_data_perform_t capturedBlock = capturedBlocks[0];
    XCTAssertEqualObjects(capturedBlock, multiBlockOne, @"The blocks to perform should be captured in order");
    capturedBlock();
    XCTAssertTrue(blockOnePerformed, @"The first block should have been performed now");
    capturedBlock = capturedBlocks[1];
    XCTAssertEqualObjects(capturedBlock, multiBlockTwo, @"The blocks to perform should be captured in order");
    capturedBlock();
    XCTAssertTrue(blockTwoPerformed, @"The second block should have been performed now");
    capturedBlock = capturedBlocks[2];
    XCTAssertEqualObjects(capturedBlock, multiBlockThree, @"The blocks to perform should be captured in order");
    capturedBlock();
    XCTAssertTrue(blockThreePerformed, @"The third block should have been performed now");
    [LTTCoreDataAuditor stopAuditingPerformMultipleBlocks];
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

- (void)testAuditingOfNestedPerformBlockAndWait {
    __block BOOL otherBlockPerformed = NO;
    core_data_perform_t otherBlockToPerform = ^{
        otherBlockPerformed = YES;
    };

    __block BOOL blockPerformed = NO;
    __block __weak NSManagedObjectContext *weakContext = context;
    blockToPerform = ^{
        blockPerformed = YES;
        [weakContext performBlockAndWait:otherBlockToPerform];
    };
    
    [LTTCoreDataAuditor auditPerformBlockAndWait];
    [context performBlockAndWait:blockToPerform];
    core_data_perform_t capturedBlock = [LTTCoreDataAuditor blockToPerform];
    XCTAssertEqualObjects(capturedBlock, blockToPerform, @"The block to perform should be captured");
    XCTAssertFalse(blockPerformed, @"The block should not have been performed");
    [LTTCoreDataAuditor stopAuditingPerformBlockAndWait];
    [LTTCoreDataAuditor auditPerformBlockAndWait];
    capturedBlock();
    core_data_perform_t otherCapturedBlock = [LTTCoreDataAuditor blockToPerform];
    XCTAssertEqualObjects(otherCapturedBlock, otherBlockToPerform, @"The second block to perform should be captured");
    XCTAssertFalse(otherBlockPerformed, @"The block should not have been performed");
    otherCapturedBlock();
    XCTAssertTrue(otherBlockPerformed, @"The block should have been performed now");
    [LTTCoreDataAuditor stopAuditingPerformBlockAndWait];
}

- (void) testAuditingPerformMultipleBlocksAndWaitSwizzlesMethods {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlockAndWait:)));
    [LTTCoreDataAuditor auditPerformMultipleBlocksAndWait];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlockAndWait:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [LTTCoreDataAuditor stopAuditingPerformMultipleBlocksAndWait];
    currentImplementation = method_getImplementation(class_getInstanceMethod([NSManagedObjectContext class], @selector(performBlockAndWait:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingPerformMultipleBlocksAndWaitCapturesBlocks {
    __block BOOL blockOnePerformed = NO;
    multiBlockOne = ^ {
        blockOnePerformed = YES;
    };
    __block BOOL blockTwoPerformed = NO;
    multiBlockTwo = ^ {
        blockTwoPerformed = YES;
    };
    __block BOOL blockThreePerformed = NO;
    multiBlockThree = ^ {
        blockThreePerformed = YES;
    };
    [LTTCoreDataAuditor auditPerformMultipleBlocksAndWait];
    [context performBlockAndWait:multiBlockOne];
    [context performBlockAndWait:multiBlockTwo];
    [context performBlockAndWait:multiBlockThree];
    NSArray *capturedBlocks = [LTTCoreDataAuditor blocksToPerform];
    XCTAssertEqual(capturedBlocks.count, (NSUInteger)3, @"There should be three blocks captured");
    XCTAssertFalse(blockOnePerformed, @"The first block should not have been performed");
    XCTAssertFalse(blockTwoPerformed, @"The second block should not have been performed");
    XCTAssertFalse(blockThreePerformed, @"The third block should not have been performed");
    core_data_perform_t capturedBlock = capturedBlocks[0];
    XCTAssertEqualObjects(capturedBlock, multiBlockOne, @"The blocks to perform should be captured in order");
    capturedBlock();
    XCTAssertTrue(blockOnePerformed, @"The first block should have been performed now");
    capturedBlock = capturedBlocks[1];
    XCTAssertEqualObjects(capturedBlock, multiBlockTwo, @"The blocks to perform should be captured in order");
    capturedBlock();
    XCTAssertTrue(blockTwoPerformed, @"The second block should have been performed now");
    capturedBlock = capturedBlocks[2];
    XCTAssertEqualObjects(capturedBlock, multiBlockThree, @"The blocks to perform should be captured in order");
    capturedBlock();
    XCTAssertTrue(blockThreePerformed, @"The third block should have been performed now");
    [LTTCoreDataAuditor stopAuditingPerformMultipleBlocksAndWait];
}


@end

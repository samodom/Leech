//
//  MockURLDataTaskTests.m
//  Leech
//
//  Created by Sam Odom on 2/26/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTMockURLDataTask.h"

@interface MockURLDataTaskTests : XCTestCase

@end

@implementation MockURLDataTaskTests {
    LTTMockURLDataTask *task;
}

- (void)setUp {
    [super setUp];

    task = [LTTMockURLDataTask new];
}

- (void)tearDown {
    task = nil;

    [super tearDown];
}

- (void)testCanCreateMockURLDataTask {
    XCTAssertTrue([task isKindOfClass:[LTTMockURLDataTask class]], @"Should be able to create a new mock URL data task");
}

- (void)testTaskHasState {
    task.state = NSURLSessionTaskStateRunning;
    XCTAssertEqual(task.state, NSURLSessionTaskStateRunning, @"Task should remember its state");
}

- (void)testTaskCanBeCanceled {
    XCTAssertFalse([task wasAskedToCancel], @"Task should not report having been asked to cancel by default");
    [(NSURLSessionDataTask*)task cancel];
    XCTAssertTrue([task wasAskedToCancel], @"Task should report having been asked to cancel");
}

@end

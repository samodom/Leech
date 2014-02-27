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
    NSURL *URL;
}

- (void)setUp {
    [super setUp];

    task = [LTTMockURLDataTask new];
    URL = [NSURL URLWithString:@"http://www.example.com/"];
}

- (void)tearDown {
    URL = nil;
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

- (void)testTaskHasURL {
    task.URL = URL;
    XCTAssertEqualObjects(task.URL, URL, @"Task should remember its URL");
}

- (void)testTaskProvidesOriginalRequestWithURL {
    task.URL = URL;
    NSURLRequest *request = [(NSURLSessionDataTask*)task originalRequest];
    XCTAssertTrue([request isKindOfClass:[NSURLRequest class]], @"Task should return an original URL request");
    XCTAssertEqualObjects(request.URL, URL, @"The request should have the task's URL");
}

- (void)testTaskHasCompletionHandler {
    __block BOOL blockPerformed = NO;
    data_task_completion_t handler = ^(NSData *data, NSURLResponse *response, NSError *error) {
        blockPerformed = YES;
    };
    task.completionHandler = handler;
    task.completionHandler(nil, nil, nil);
    XCTAssertEqualObjects(task.completionHandler, handler, @"Task should remember its completion handler");
    XCTAssertTrue(blockPerformed, @"The block should be executable");
}

- (void)testTaskCanBeResumed {
    XCTAssertFalse([task wasAskedToResume], @"Task should not report having been asked to resume by default");
    [(NSURLSessionDataTask*)task resume];
    XCTAssertTrue([task wasAskedToResume], @"Task should report having been asked to resume");
    XCTAssertEqual(task.state, NSURLSessionTaskStateRunning, @"The state should reflect the task running");
}

- (void)testTaskCanBeSuspended {
    XCTAssertFalse([task wasAskedToSuspend], @"Task should report being suspended by default");
    [(NSURLSessionDataTask*)task resume];
    [(NSURLSessionDataTask*)task suspend];
    XCTAssertTrue([task wasAskedToSuspend], @"Task should report having been asked to suspend");
    XCTAssertEqual(task.state, NSURLSessionTaskStateSuspended, @"The state should reflect the task being suspended");
}

- (void)testTaskCanBeCanceled {
    XCTAssertFalse([task wasAskedToCancel], @"Task should not report having been asked to cancel by default");
    [(NSURLSessionDataTask*)task cancel];
    XCTAssertTrue([task wasAskedToCancel], @"Task should report having been asked to cancel");
    XCTAssertEqual(task.state, NSURLSessionTaskStateCanceling, @"The state should reflect the task canceling");
}

@end

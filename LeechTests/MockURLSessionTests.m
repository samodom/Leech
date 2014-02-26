//
//  MockURLSessionTests.m
//  Leech
//
//  Created by Sam Odom on 2/26/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTMockURLSession.h"
#import "LTTMockURLDataTask.h"

@interface MockURLSessionTests : XCTestCase

@end

@implementation MockURLSessionTests {
    LTTMockURLSession *session;
    NSURL *URL;
}

- (void)setUp {
    [super setUp];

    session = [LTTMockURLSession new];
    URL = [NSURL URLWithString:@"http://www.example.com"];
}

- (void)tearDown {
    URL = nil;
    session = nil;

    [super tearDown];
}

- (void)testCanCreateNewMockURLSession {
    XCTAssertTrue([session isKindOfClass:[LTTMockURLSession class]], @"Should be able to create a new mock URL session");
}

- (void)testSessionCapturesDataTaskCreationParameters {
    data_task_completion_t handler = ^(NSData *data, NSURLResponse *response, NSError *error) {
        ;
    };
    LTTMockURLDataTask *task = (LTTMockURLDataTask*) [(NSURLSession*)session dataTaskWithURL:URL completionHandler:handler];
    XCTAssertTrue([task isKindOfClass:[LTTMockURLDataTask class]], @"A mock data task should be returned");
    XCTAssertEqualObjects(task.URL, URL, @"Mock task should be passed the URL");
    XCTAssertEqualObjects(task.completionHandler, handler, @"Mock task should be passed the completion handler");
}

@end

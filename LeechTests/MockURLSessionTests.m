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
    NSURL *dataURLOne, *dataURLTwo;
}

- (void)setUp {
    [super setUp];

    session = [LTTMockURLSession new];
    dataURLOne = [NSURL URLWithString:@"http://www.example.com/one"];
    dataURLTwo = [NSURL URLWithString:@"http://www.example.com/two"];
}

- (void)tearDown {
    dataURLOne = nil;
    dataURLTwo = nil;
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
    LTTMockURLDataTask *task = (LTTMockURLDataTask*) [(NSURLSession*)session dataTaskWithURL:dataURLOne completionHandler:handler];
    XCTAssertTrue([task isKindOfClass:[LTTMockURLDataTask class]], @"A mock data task should be returned");
    XCTAssertEqualObjects(task.URL, dataURLOne, @"Mock task should be passed the URL");
    XCTAssertEqualObjects(task.completionHandler, handler, @"Mock task should be passed the completion handler");
}

- (void)testSessionProvidesTasksWithCompletionHandler {
    __block NSArray *currentDataTasks;
    task_list_completion_t handler = ^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        currentDataTasks = dataTasks;
    };
    [(NSURLSession*)session getTasksWithCompletionHandler:handler];
    XCTAssertEqual(currentDataTasks.count, (NSUInteger)0, @"There should be no tasks");
    LTTMockURLDataTask *dataTaskOne = (LTTMockURLDataTask*) [(NSURLSession*)session dataTaskWithURL:dataURLOne completionHandler:nil];
    [(NSURLSessionDataTask*)dataTaskOne resume];
    [(NSURLSession*)session getTasksWithCompletionHandler:handler];
    XCTAssertEqualObjects(currentDataTasks, @[dataTaskOne], @"There should be one task");
    LTTMockURLDataTask *dataTaskTwo = (LTTMockURLDataTask*) [(NSURLSession*)session dataTaskWithURL:dataURLTwo completionHandler:nil];
    [(NSURLSessionDataTask*)dataTaskTwo resume];
    [(NSURLSession*)session getTasksWithCompletionHandler:handler];
    NSArray *expected = @[dataTaskOne, dataTaskTwo];
    XCTAssertEqualObjects(currentDataTasks, expected, @"There should be two tasks");
    [(NSURLSessionDataTask*)dataTaskOne suspend];
    [(NSURLSession*)session getTasksWithCompletionHandler:handler];
    XCTAssertEqualObjects(currentDataTasks, expected, @"There should still be two tasks");
    [(NSURLSessionDataTask*)dataTaskOne cancel];
    [(NSURLSession*)session getTasksWithCompletionHandler:handler];
    XCTAssertEqualObjects(currentDataTasks, @[dataTaskOne], @"There should only be one task left");
    [(NSURLSessionDataTask*)dataTaskTwo cancel];
    [(NSURLSession*)session getTasksWithCompletionHandler:handler];
    XCTAssertEqual(currentDataTasks.count, (NSUInteger)0, @"There should be no tasks left");
}

@end

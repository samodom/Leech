//
//  MockHTTPResponseTests.m
//  Leech
//
//  Created by Sam Odom on 2/25/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTMockHTTPResponse.h"

@interface MockHTTPResponseTests : XCTestCase

@end

@implementation MockHTTPResponseTests {
    NSString *path;
    LTTMockHTTPResponse *response;
}

- (void)setUp {
    [super setUp];

    path = [[NSBundle mainBundle] pathForResource:@"Boston City Flow" ofType:@"jpg"];
    response = [LTTMockHTTPResponse responseWithStatus:200 payloadFile:@"Boston City Flow" ofType:@"jpg"];
}

- (void)tearDown {
    path = nil;
    response = nil;

    [super tearDown];
}

- (void)testCanCreateMockResponseWithStatusAndPayload {
    XCTAssertTrue([response isKindOfClass:[LTTMockHTTPResponse class]], @"Should be able to create a new mock response");
}

- (void)testResponseHasStatusCode {
    XCTAssertEqual(response.statusCode, (NSUInteger)200, @"Response should keep track of its status code");
}

- (void)testResponseLoadsPayloadFromFile {
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertEqualObjects(data, response.responseData, @"Constructor should load contents of file as response data");
}

- (void)testPayloadCanBeEmpty {
    response = [LTTMockHTTPResponse responseWithStatus:404 payloadFile:nil ofType:nil];
    XCTAssertTrue([response isKindOfClass:[LTTMockHTTPResponse class]], @"There should still be a response created");
    XCTAssertNil(response.responseData, @"There should be no response data with an empty payload");
}

@end

//
//  SampleFileLoaderTests.m
//  Leech
//
//  Created by Sam Odom on 2/28/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTSampleFileLoader.h"

@interface SampleFileLoaderTests : XCTestCase

@end

@implementation SampleFileLoaderTests {

}

- (void)setUp {
    [super setUp];

}

- (void)tearDown {

    [super tearDown];
}

- (void)testCanLoadDictionaryFromJSONFile {
    NSDictionary *expected = @{ @"alpha": @"bravo", @"charlie": @"delta" };
    NSDictionary *parsed = [LTTSampleFileLoader loadDictionaryFromJSONFile:@"dictionary"];
    XCTAssertEqualObjects(parsed, expected, @"The loader should load the file and parse the dictionary");
}

- (void)testCanLoadArrayFromJSONFile {
    NSArray *expected = @[ @{ @"alpha": @"bravo" }, @{ @"charlie": @"delta" } ];
    NSArray *parsed = [LTTSampleFileLoader loadArrayFromJSONFile:@"array"];
    XCTAssertEqualObjects(parsed, expected, @"The loader should load the file and parse the array");
}

@end

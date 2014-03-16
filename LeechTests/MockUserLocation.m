//
//  MockUserLocation.m
//  Leech
//
//  Created by Sam Odom on 3/15/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MapKit/MapKit.h>

//  Mocks+


//  Production
#import "LTTMockUserLocation.h"

@interface MockUserLocation : XCTestCase

@end

@implementation MockUserLocation {
    LTTMockUserLocation *userLocation;
}

- (void)setUp {
    [super setUp];

    userLocation = [LTTMockUserLocation new];
}

- (void)tearDown {
    userLocation = nil;

    [super tearDown];
}

- (void)testCanCreateMockUserLocation {
    XCTAssertTrue([userLocation isKindOfClass:[LTTMockUserLocation class]], @"Should be able to create a new mock user location");
}

- (void)testUserLocationHasLocation {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:12.0 longitude:-24.0];
    userLocation.location = location;
    XCTAssertEqualObjects(userLocation.location, location, @"The user location should keep track of its actual location");
}

@end

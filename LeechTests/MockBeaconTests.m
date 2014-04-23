//
//  MockBeaconTests.m
//  Leech
//
//  Created by Sam Odom on 4/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>

//  Mocks+


//  Production
#import "LTTMockBeacon.h"


@interface MockBeaconTests : XCTestCase

@end

@implementation MockBeaconTests {
    LTTMockBeacon *beacon;
}

- (void)setUp {
    [super setUp];

    beacon = [LTTMockBeacon new];
}

- (void)tearDown {
    beacon = nil;

    [super tearDown];
}

- (void)testBeaconHasProximityUUID {
    NSUUID *uuid = [NSUUID UUID];
    beacon.proximityUUID = uuid;
    XCTAssertEqualObjects(beacon.proximityUUID, uuid, @"The beacon should keep track of its proximity UUID");
}

- (void)testBeaconHasMajorNumber {
    beacon.major = @(14);
    XCTAssertEqualObjects(beacon.major, @(14), @"The beacon should keep track of its major number");
}

- (void)testBeaconHasMinorNumber {
    beacon.minor = @(42);
    XCTAssertEqualObjects(beacon.minor, @(42), @"The beacon should keep track of its minor number");
}

- (void)testBeaconHasProximity {
    beacon.proximity = CLProximityNear;
    XCTAssertEqual(beacon.proximity, CLProximityNear, @"The beacon should keep track of its proximity");
}

- (void)testBeaconHasAccuracy {
    beacon.accuracy = 2.0;
    XCTAssertEqual(beacon.accuracy, (CLLocationAccuracy)2.0, @"The beacon should keep track of its accuracy");
}

- (void)testBeaconHasRSSI {
    beacon.rssi = 24;
    XCTAssertEqual(beacon.rssi, (NSInteger)24, @"The beacon should keep track of its RSSI value");
}

@end

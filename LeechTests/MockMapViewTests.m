//
//  MockMapViewTests.m
//  Leech
//
//  Created by Sam Odom on 3/15/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MapKit/MapKit.h>

//  Mocks+


//  Production
#import "LTTMockMapView.h"

@interface MockMapViewTests : XCTestCase

@end

@implementation MockMapViewTests {
    LTTMockMapView *mapView;
}

- (void)setUp {
    [super setUp];

    mapView = [LTTMockMapView new];
}

- (void)tearDown {
    mapView = nil;

    [super tearDown];
}

- (void)testCanCreateMockMapView {
    XCTAssertTrue([mapView isKindOfClass:[LTTMockMapView class]], @"Should be able to create a new mock map view");
}

- (void)testMapViewHasEditableUserLocation {
    MKUserLocation *location = [MKUserLocation new];
    mapView.userLocation = location;
    XCTAssertEqualObjects(mapView.userLocation, location, @"The map view should keep track of its user location");
}

- (void)testMapHasEditableRegion {
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(10.0, 12.0), MKCoordinateSpanMake(2.0, 4.0));
    mapView.region = region;
    XCTAssertEqual(mapView.region.center.latitude, region.center.latitude, @"The region center should match");
    XCTAssertEqual(mapView.region.center.longitude, region.center.longitude, @"The region center should match");
    XCTAssertEqual(mapView.region.span.latitudeDelta, region.span.latitudeDelta, @"The region span should match");
    XCTAssertEqual(mapView.region.span.longitudeDelta, region.span.longitudeDelta, @"The region span should match");
}

@end

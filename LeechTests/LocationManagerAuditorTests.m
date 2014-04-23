//
//  LocationManagerAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 4/22/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>

//  Mocks+


//  Production
#import "LTTLocationManagerAuditor.h"


@interface LocationManagerAuditorTests : XCTestCase

@end

@implementation LocationManagerAuditorTests {
    CLLocationManager *locationManager;
}

- (void)setUp {
    [super setUp];

    locationManager = [CLLocationManager new];
}

- (void)tearDown {
    locationManager = nil;

    [super tearDown];
}

#pragma mark - Region monitoring

- (void)testAuditorOverridesMonitoringAvailabilityForClassMethod {
    IMP realImplementation = method_getImplementation(class_getClassMethod([CLLocationManager class], @selector(isMonitoringAvailableForClass:)));
    [LTTLocationManagerAuditor overrideMonitoringAvailable];
    IMP currentImplementation = method_getImplementation(class_getClassMethod([CLLocationManager class], @selector(isMonitoringAvailableForClass:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    BOOL monitoringAvailable = [CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]];
    XCTAssertFalse(monitoringAvailable, @"The location manager should not indicate monitoring availability by default");
    [LTTLocationManagerAuditor setMonitoringAvailable:YES forClass:[CLBeaconRegion class]];
    monitoringAvailable = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    XCTAssertTrue(monitoringAvailable, @"The location manager should remember monitoring availability by class");
    [LTTLocationManagerAuditor reverseMonitoringAvailableOverride];
    currentImplementation = method_getImplementation(class_getClassMethod([CLLocationManager class], @selector(isMonitoringAvailableForClass:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorCapturesRegionToStartMonitoring {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(24.0, -12.0);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:14.2 identifier:@"circular region"];
    [LTTLocationManagerAuditor auditStartMonitoringForRegionMethod:locationManager];
    [locationManager startMonitoringForRegion:region];
    CLRegion *capturedRegion = [LTTLocationManagerAuditor regionToStartMonitoring:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to start monitoring should be captured");
    [LTTLocationManagerAuditor stopAuditingStartMonitoringForRegionMethod:locationManager];
}

- (void)testAuditorCapturesRegionToStopMonitoring {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(24.0, -12.0);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:14.2 identifier:@"circular region"];
    [LTTLocationManagerAuditor auditStopMonitoringForRegionMethod:locationManager];
    [locationManager stopMonitoringForRegion:region];
    CLRegion *capturedRegion = [LTTLocationManagerAuditor regionToStopMonitoring:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to stop monitoring should be captured");
    [LTTLocationManagerAuditor stopAuditingStopMonitoringForRegionMethod:locationManager];
}

#pragma mark - Beacon ranging

- (void)testAuditorOverridesRangingAvailabilityMethod {
    IMP realImplementation = method_getImplementation(class_getClassMethod([CLLocationManager class], @selector(isRangingAvailable)));
    [LTTLocationManagerAuditor overrideRangingAvailable];
    IMP currentImplementation = method_getImplementation(class_getClassMethod([CLLocationManager class], @selector(isRangingAvailable)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    BOOL rangingAvailable = [CLLocationManager isRangingAvailable];
    XCTAssertFalse(rangingAvailable, @"The mock location manager should not indicate ranging availability by default");
    [LTTLocationManagerAuditor setRangingAvailable:YES];
    rangingAvailable = [CLLocationManager isRangingAvailable];
    XCTAssertTrue(rangingAvailable, @"The mock location manager should remember ranging availability when set");
    [LTTLocationManagerAuditor reverseRangingAvailableOverride];
    currentImplementation = method_getImplementation(class_getClassMethod([CLLocationManager class], @selector(isRangingAvailable)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorCapturesBeaconRegionToStartRanging {
    NSUUID *uuid = [NSUUID UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    [LTTLocationManagerAuditor auditStartRangingBeaconsInRegionMethod:locationManager];
    [locationManager startRangingBeaconsInRegion:region];
    CLBeaconRegion *capturedRegion = [LTTLocationManagerAuditor regionToStartRanging:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to start ranging should be captured");
    [LTTLocationManagerAuditor stopAuditingStartRangingBeaconsInRegionMethod:locationManager];
}

- (void)testAuditorCapturesBeaconRegionToStopRanging {
    NSUUID *uuid = [NSUUID UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    [LTTLocationManagerAuditor auditStopRangingBeaconsInRegionMethod:locationManager];
    [locationManager stopRangingBeaconsInRegion:region];
    CLBeaconRegion *capturedRegion = [LTTLocationManagerAuditor regionToStopRanging:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to stop ranging should be captured");
    [LTTLocationManagerAuditor stopAuditingStopRangingBeaconsInRegionMethod:locationManager];
}

@end

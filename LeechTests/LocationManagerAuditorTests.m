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
#import "LTTMockHeading.h"

@interface LocationManagerAuditorTests : XCTestCase

@end

@implementation LocationManagerAuditorTests {
    CLLocationManager *locationManager;
    IMP realImplementation, currentImplementation;
}

- (void)setUp {
    [super setUp];

    locationManager = [CLLocationManager new];
}

- (void)tearDown {
    locationManager = nil;
    realImplementation = nil;
    currentImplementation = nil;

    [super tearDown];
}

- (Method)classMethod:(SEL)selector {
    return class_getClassMethod([CLLocationManager class], selector);
}

- (Method)instanceMethod:(SEL)selector {
    return class_getInstanceMethod([CLLocationManager class], selector);
}

- (IMP)classMethodImplementation:(SEL)selector {
    Method method = [self classMethod:selector];
    return method_getImplementation(method);
}

- (IMP)instanceMethodImplementation:(SEL)selector {
    Method method = [self instanceMethod:selector];
    return method_getImplementation(method);
}

#pragma mark - Region monitoring

- (void)testAuditorOverridesMonitoringAvailabilityForClassMethod {
    realImplementation = [self classMethodImplementation:@selector(isMonitoringAvailableForClass:)];
    [LTTLocationManagerAuditor overrideMonitoringAvailable];
    currentImplementation = [self classMethodImplementation:@selector(isMonitoringAvailableForClass:)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    BOOL monitoringAvailable = [CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]];
    XCTAssertFalse(monitoringAvailable, @"The location manager should not indicate monitoring availability by default");
    [LTTLocationManagerAuditor setMonitoringAvailable:YES forClass:[CLBeaconRegion class]];
    monitoringAvailable = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    XCTAssertTrue(monitoringAvailable, @"The location manager should remember monitoring availability by class");
    [LTTLocationManagerAuditor reverseMonitoringAvailableOverride];
    currentImplementation = [self classMethodImplementation:@selector(isMonitoringAvailableForClass:)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorCapturesRegionToStartMonitoring {
    realImplementation = [self instanceMethodImplementation:@selector(startMonitoringForRegion:)];
    IMP realAccessorImplementation = [self instanceMethodImplementation:@selector(monitoredRegions)];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(24.0, -12.0);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:14.2 identifier:@"circular region"];
    [LTTLocationManagerAuditor auditStartMonitoringForRegionMethod:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(startMonitoringForRegion:)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    IMP currentAccessorImplementation = [self instanceMethodImplementation:@selector(monitoredRegions)];
    XCTAssertNotEqual(currentAccessorImplementation, realAccessorImplementation, @"The method should be swizzled");
    [locationManager startMonitoringForRegion:region];
    CLRegion *capturedRegion = [LTTLocationManagerAuditor regionToStartMonitoring:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to start monitoring should be captured");
    NSSet *monitoredRegions = [locationManager monitoredRegions];
    XCTAssertEqualObjects(monitoredRegions, [NSSet setWithObject:region], @"The monitored regions should be available");
    [LTTLocationManagerAuditor stopAuditingStartMonitoringForRegionMethod:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(startMonitoringForRegion:)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
    currentAccessorImplementation = [self instanceMethodImplementation:@selector(monitoredRegions)];
    XCTAssertEqual(currentAccessorImplementation, realAccessorImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorAllowsSettingOfMonitoredRegions {
    realImplementation = [self instanceMethodImplementation:@selector(monitoredRegions)];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(24.0, -12.0);
    CLCircularRegion *regionOne = [[CLCircularRegion alloc] initWithCenter:center radius:14.2 identifier:@"circular region one"];
    CLCircularRegion *regionTwo = [[CLCircularRegion alloc] initWithCenter:center radius:42.8 identifier:@"circular region two"];
    NSSet *regions = [NSSet setWithObjects:regionOne, regionTwo, nil];
    [LTTLocationManagerAuditor setMonitoredRegions:regions forLocationManager:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(monitoredRegions)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSSet *monitoredRegions = [locationManager monitoredRegions];
    XCTAssertEqualObjects(monitoredRegions, regions, @"The monitored regions should be remebered");
    [LTTLocationManagerAuditor clearMonitoredRegionsForLocationManager:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(monitoredRegions)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorCapturesRegionToStopMonitoring {
    realImplementation = [self instanceMethodImplementation:@selector(stopMonitoringForRegion:)];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(24.0, -12.0);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:14.2 identifier:@"circular region"];
    [LTTLocationManagerAuditor auditStopMonitoringForRegionMethod:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(stopMonitoringForRegion:)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [locationManager stopMonitoringForRegion:region];
    CLRegion *capturedRegion = [LTTLocationManagerAuditor regionToStopMonitoring:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to stop monitoring should be captured");
    [LTTLocationManagerAuditor stopAuditingStopMonitoringForRegionMethod:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(stopMonitoringForRegion:)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

#pragma mark - Beacon ranging

- (void)testAuditorOverridesRangingAvailabilityMethod {
    realImplementation = [self classMethodImplementation:@selector(isRangingAvailable)];
    [LTTLocationManagerAuditor overrideRangingAvailable];
    currentImplementation = [self classMethodImplementation:@selector(isRangingAvailable)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    BOOL rangingAvailable = [CLLocationManager isRangingAvailable];
    XCTAssertFalse(rangingAvailable, @"The mock location manager should not indicate ranging availability by default");
    [LTTLocationManagerAuditor setRangingAvailable:YES];
    rangingAvailable = [CLLocationManager isRangingAvailable];
    XCTAssertTrue(rangingAvailable, @"The mock location manager should remember ranging availability when set");
    [LTTLocationManagerAuditor reverseRangingAvailableOverride];
    currentImplementation = [self classMethodImplementation:@selector(isRangingAvailable)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorCapturesBeaconRegionToStartRanging {
    realImplementation = [self instanceMethodImplementation:@selector(startRangingBeaconsInRegion:)];
    IMP realAccessorImplementation = [self instanceMethodImplementation:@selector(rangedRegions)];
    NSUUID *uuid = [NSUUID UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    [LTTLocationManagerAuditor auditStartRangingBeaconsInRegionMethod:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(startRangingBeaconsInRegion:)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    IMP currentAccessorImplementation = [self instanceMethodImplementation:@selector(rangedRegions)];
    XCTAssertNotEqual(currentAccessorImplementation, realAccessorImplementation, @"The method should be swizzled");
    [locationManager startRangingBeaconsInRegion:region];
    CLBeaconRegion *capturedRegion = [LTTLocationManagerAuditor regionToStartRanging:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to start ranging should be captured");
    NSSet *rangedRegions = [locationManager rangedRegions];
    XCTAssertEqualObjects(rangedRegions, [NSSet setWithObject:region], @"The ranged regions should be available");
    [LTTLocationManagerAuditor stopAuditingStartRangingBeaconsInRegionMethod:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(startRangingBeaconsInRegion:)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
    currentAccessorImplementation = [self instanceMethodImplementation:@selector(rangedRegions)];
    XCTAssertEqual(currentAccessorImplementation, realAccessorImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorCapturesBeaconRegionToStopRanging {
    realImplementation = [self instanceMethodImplementation:@selector(stopRangingBeaconsInRegion:)];
    NSUUID *uuid = [NSUUID UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    [LTTLocationManagerAuditor auditStopRangingBeaconsInRegionMethod:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(stopRangingBeaconsInRegion:)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [locationManager stopRangingBeaconsInRegion:region];
    CLBeaconRegion *capturedRegion = [LTTLocationManagerAuditor regionToStopRanging:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to stop ranging should be captured");
    [LTTLocationManagerAuditor stopAuditingStopRangingBeaconsInRegionMethod:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(stopRangingBeaconsInRegion:)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorAllowsSettingOfRangedRegions {
    realImplementation = [self instanceMethodImplementation:@selector(rangedRegions)];
    NSUUID *uuid = [NSUUID UUID];
    CLBeaconRegion *regionOne = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    uuid = [NSUUID UUID];
    CLBeaconRegion *regionTwo = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    NSSet *regions = [NSSet setWithObjects:regionOne, regionTwo, nil];
    [LTTLocationManagerAuditor setRangedRegions:regions forLocationManager:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(rangedRegions)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSSet *rangedRegions = [locationManager rangedRegions];
    XCTAssertEqualObjects(rangedRegions, regions, @"The ranged regions should be remebered");
    [LTTLocationManagerAuditor clearRangedRegionsForLocationManager:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(rangedRegions)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

#pragma mark - Heading

- (void)testAuditorOverridesHeadingAvailabilityMethod {
    realImplementation = [self classMethodImplementation:@selector(headingAvailable)];
    [LTTLocationManagerAuditor overrideHeadingAvailable];
    currentImplementation = [self classMethodImplementation:@selector(headingAvailable)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    XCTAssertFalse([CLLocationManager headingAvailable], @"The location manager should not indicate heading availability by default");
    [LTTLocationManagerAuditor setHeadingAvailable:YES];
    XCTAssertTrue([CLLocationManager headingAvailable], @"The location manager should remember heading availability");
    [LTTLocationManagerAuditor setHeadingAvailable:NO];
    XCTAssertFalse([CLLocationManager headingAvailable], @"The location manager should remember heading availability");
    [LTTLocationManagerAuditor reverseHeadingAvailableOverride];
    currentImplementation = [self classMethodImplementation:@selector(headingAvailable)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testStartUpdatingHeading {
    realImplementation = [self instanceMethodImplementation:@selector(startUpdatingHeading)];
    [LTTLocationManagerAuditor auditStartUpdatingHeading:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(startUpdatingHeading)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [locationManager startUpdatingHeading];
    XCTAssertTrue([LTTLocationManagerAuditor startedUpdatingHeading:locationManager], @"The auditor should capture the call to start updating the heading");
    [LTTLocationManagerAuditor stopAuditingStartUpdatingHeading:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(startUpdatingHeading)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testStopUpdatingHeading {
    realImplementation = [self instanceMethodImplementation:@selector(stopUpdatingHeading)];
    [LTTLocationManagerAuditor auditStopUpdatingHeading:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(stopUpdatingHeading)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [locationManager stopUpdatingHeading];
    XCTAssertTrue([LTTLocationManagerAuditor stoppedUpdatingHeading:locationManager], @"The auditor should capture the call to stop updating the heading");
    [LTTLocationManagerAuditor stopAuditingStopUpdatingHeading:locationManager];
    currentImplementation = [self instanceMethodImplementation:@selector(stopUpdatingHeading)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testHeadingOverride {
    XCTAssertNil(locationManager.heading, @"The heading should be missing by default");
    realImplementation = [self instanceMethodImplementation:@selector(heading)];
    [LTTLocationManagerAuditor overrideHeading];
    XCTAssertNil(locationManager.heading, @"The heading should still be missing");
    currentImplementation = [self instanceMethodImplementation:@selector(heading)];
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    LTTMockHeading *heading = [LTTMockHeading new];
    [LTTLocationManagerAuditor setHeadingOverride:heading forLocationManager:locationManager];
    XCTAssertEqualObjects(locationManager.heading, heading, @"The override heading should be returned");
    [LTTLocationManagerAuditor clearHeadingOverrideForLocationManager:locationManager];
    XCTAssertNil(locationManager.heading, @"The heading should be missing again");
    [LTTLocationManagerAuditor setHeadingOverride:heading forLocationManager:locationManager];
    [LTTLocationManagerAuditor reverseHeadingOverride];
    XCTAssertNil(locationManager.heading, @"The heading should be missing again");
    currentImplementation = [self instanceMethodImplementation:@selector(heading)];
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end

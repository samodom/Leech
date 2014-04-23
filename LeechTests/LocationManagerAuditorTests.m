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
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(startMonitoringForRegion:)));
    IMP realAccessorImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(monitoredRegions)));
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(24.0, -12.0);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:14.2 identifier:@"circular region"];
    [LTTLocationManagerAuditor auditStartMonitoringForRegionMethod:locationManager];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(startMonitoringForRegion:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    IMP currentAccessorImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(monitoredRegions)));
    XCTAssertNotEqual(currentAccessorImplementation, realAccessorImplementation, @"The method should be swizzled");
    [locationManager startMonitoringForRegion:region];
    CLRegion *capturedRegion = [LTTLocationManagerAuditor regionToStartMonitoring:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to start monitoring should be captured");
    NSSet *monitoredRegions = [locationManager monitoredRegions];
    XCTAssertEqualObjects(monitoredRegions, [NSSet setWithObject:region], @"The monitored regions should be available");
    [LTTLocationManagerAuditor stopAuditingStartMonitoringForRegionMethod:locationManager];
    currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(startMonitoringForRegion:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
    currentAccessorImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(monitoredRegions)));
    XCTAssertEqual(currentAccessorImplementation, realAccessorImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorAllowsSettingOfMonitoredRegions {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(monitoredRegions)));
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(24.0, -12.0);
    CLCircularRegion *regionOne = [[CLCircularRegion alloc] initWithCenter:center radius:14.2 identifier:@"circular region one"];
    CLCircularRegion *regionTwo = [[CLCircularRegion alloc] initWithCenter:center radius:42.8 identifier:@"circular region two"];
    NSSet *regions = [NSSet setWithObjects:regionOne, regionTwo, nil];
    [LTTLocationManagerAuditor setMonitoredRegions:regions forLocationManager:locationManager];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(monitoredRegions)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSSet *monitoredRegions = [locationManager monitoredRegions];
    XCTAssertEqualObjects(monitoredRegions, regions, @"The monitored regions should be remebered");
    [LTTLocationManagerAuditor clearMonitoredRegionsForLocationManager:locationManager];
    currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(monitoredRegions)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorCapturesRegionToStopMonitoring {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(stopMonitoringForRegion:)));
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(24.0, -12.0);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:14.2 identifier:@"circular region"];
    [LTTLocationManagerAuditor auditStopMonitoringForRegionMethod:locationManager];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(stopMonitoringForRegion:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [locationManager stopMonitoringForRegion:region];
    CLRegion *capturedRegion = [LTTLocationManagerAuditor regionToStopMonitoring:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to stop monitoring should be captured");
    [LTTLocationManagerAuditor stopAuditingStopMonitoringForRegionMethod:locationManager];
    currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(stopMonitoringForRegion:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
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
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(startRangingBeaconsInRegion:)));
    IMP realAccessorImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(rangedRegions)));
    NSUUID *uuid = [NSUUID UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    [LTTLocationManagerAuditor auditStartRangingBeaconsInRegionMethod:locationManager];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(startRangingBeaconsInRegion:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    IMP currentAccessorImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(rangedRegions)));
    XCTAssertNotEqual(currentAccessorImplementation, realAccessorImplementation, @"The method should be swizzled");
    [locationManager startRangingBeaconsInRegion:region];
    CLBeaconRegion *capturedRegion = [LTTLocationManagerAuditor regionToStartRanging:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to start ranging should be captured");
    NSSet *rangedRegions = [locationManager rangedRegions];
    XCTAssertEqualObjects(rangedRegions, [NSSet setWithObject:region], @"The ranged regions should be available");
    [LTTLocationManagerAuditor stopAuditingStartRangingBeaconsInRegionMethod:locationManager];
    currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(startRangingBeaconsInRegion:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
    currentAccessorImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(rangedRegions)));
    XCTAssertEqual(currentAccessorImplementation, realAccessorImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorCapturesBeaconRegionToStopRanging {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(stopRangingBeaconsInRegion:)));
    NSUUID *uuid = [NSUUID UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    [LTTLocationManagerAuditor auditStopRangingBeaconsInRegionMethod:locationManager];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(stopRangingBeaconsInRegion:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [locationManager stopRangingBeaconsInRegion:region];
    CLBeaconRegion *capturedRegion = [LTTLocationManagerAuditor regionToStopRanging:locationManager];
    XCTAssertEqualObjects(capturedRegion, region, @"The region to stop ranging should be captured");
    [LTTLocationManagerAuditor stopAuditingStopRangingBeaconsInRegionMethod:locationManager];
    currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(stopRangingBeaconsInRegion:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditorAllowsSettingOfRangedRegions {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(rangedRegions)));
    NSUUID *uuid = [NSUUID UUID];
    CLBeaconRegion *regionOne = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    uuid = [NSUUID UUID];
    CLBeaconRegion *regionTwo = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    NSSet *regions = [NSSet setWithObjects:regionOne, regionTwo, nil];
    [LTTLocationManagerAuditor setRangedRegions:regions forLocationManager:locationManager];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(rangedRegions)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSSet *rangedRegions = [locationManager rangedRegions];
    XCTAssertEqualObjects(rangedRegions, regions, @"The ranged regions should be remebered");
    [LTTLocationManagerAuditor clearRangedRegionsForLocationManager:locationManager];
    currentImplementation = method_getImplementation(class_getInstanceMethod([CLLocationManager class], @selector(rangedRegions)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end

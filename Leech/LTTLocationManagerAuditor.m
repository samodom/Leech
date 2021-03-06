//
//  LTTLocationManagerAuditor.m
//  Leech
//
//  Created by Sam Odom on 4/22/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "LTTLocationManagerAuditor.h"
#import "LTTMethodSwizzler.h"
#import "NSObject+Association.h"

const char *LTTLocationManagerAuditorRegionClassesDictionary = "LTTLocationManagerAuditorRegionClassesDictionary";
const char *LTTLocationManagerAuditorRegionToStartMonitoring = "LTTLocationManagerAuditorRegionToStartMonitoring";
const char *LTTLocationManagerAuditorRegionToStopMonitoring = "LTTLocationManagerAuditorRegionToStopMonitoring";
const char *LTTLocationManagerAuditorMonitoredRegions = "LTTLocationManagerAuditorMonitoredRegions";

const char *LTTLocationManagerAuditorRangingAvailableFlag = "LTTLocationManagerAuditorRangingAvailableFlag";
const char *LTTLocationManagerAuditorRegionToStartRanging = "LTTLocationManagerAuditorRegionToStartRanging";
const char *LTTLocationManagerAuditorRegionToStopRanging = "LTTLocationManagerAuditorRegionToStopRanging";
const char *LTTLocationManagerAuditorRangedRegions = "LTTLocationManagerAuditorRangedRegions";

const char *LTTLocationManagerAuditorHeadingAvailableFlag = "LTTLocationManagerAuditorHeadingAvailableFlag";
const char *LTTLocationManagerAuditorStartUpdatingHeadingCalled = "LTTLocationManagerAuditorStartUpdatingHeadingCalled";
const char *LTTLocationManagerAuditorStopUpdatingHeadingCalled = "LTTLocationManagerAuditorStopUpdatingHeadingCalled";
const char *LTTLocationManagerAuditorHeading = "LTTLocationManagerAuditorHeading";


////////////////////////////////////////////////////////////////////////////////
//  Category on CLLocationManager
////////////////////////////////////////////////////////////////////////////////

@implementation CLLocationManager (Leech)

#pragma mark - Region monitoring

+ (BOOL)Leech_IsMonitoringAvailableForClass:(Class)regionClass {
    NSDictionary *classes = [[LTTLocationManagerAuditor class] associationForKey:LTTLocationManagerAuditorRegionClassesDictionary];
    NSNumber *monitoringAvailable = classes[NSStringFromClass([regionClass class])];
    return monitoringAvailable.boolValue;
}

- (void)Leech_StartMonitoringForRegion:(CLRegion *)region {
    [self associateKey:LTTLocationManagerAuditorRegionToStartMonitoring withValue:region];
    [self associateKey:LTTLocationManagerAuditorMonitoredRegions withValue:[NSSet setWithObject:region]];
}

- (void)Leech_StopMonitoringForRegion:(CLRegion *)region {
    [self associateKey:LTTLocationManagerAuditorRegionToStopMonitoring withValue:region];
}

- (NSSet *)Leech_MonitoredRegions {
    return [self associationForKey:LTTLocationManagerAuditorMonitoredRegions];
}

#pragma mark - Beacon ranging

+ (BOOL)Leech_IsRangingAvailable {
    NSNumber *rangingAvailable = [[LTTLocationManagerAuditor class] associationForKey:LTTLocationManagerAuditorRangingAvailableFlag];
    return rangingAvailable.boolValue;
}

- (void)Leech_StartRangingBeaconsInRegion:(CLBeaconRegion *)region {
    [self associateKey:LTTLocationManagerAuditorRegionToStartRanging withValue:region];
    [self associateKey:LTTLocationManagerAuditorRangedRegions withValue:[NSSet setWithObject:region]];
}

- (void)Leech_StopRangingBeaconsInRegion:(CLBeaconRegion *)region {
    [self associateKey:LTTLocationManagerAuditorRegionToStopRanging withValue:region];
}

- (NSSet *)Leech_RangedRegions {
    return [self associationForKey:LTTLocationManagerAuditorRangedRegions];
}

#pragma mark - Heading updates

+ (BOOL)Leech_HeadingAvailable {
    NSNumber *headingAvailable = [[LTTLocationManagerAuditor class] associationForKey:LTTLocationManagerAuditorHeadingAvailableFlag];
    return headingAvailable.boolValue;
}

- (void)Leech_StartUpdatingHeading {
    [self associateKey:LTTLocationManagerAuditorStartUpdatingHeadingCalled withValue:@YES];
}

- (void)Leech_StopUpdatingHeading {
    [self associateKey:LTTLocationManagerAuditorStopUpdatingHeadingCalled withValue:@YES];
}

- (CLHeading *)Leech_Heading {
    return [self associationForKey:LTTLocationManagerAuditorHeading];
}

@end


////////////////////////////////////////////////////////////////////////////////
//  Location manager auditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTLocationManagerAuditor

#pragma mark - Region monitoring

#pragma mark Monitoring available

+ (void)overrideMonitoringAvailable {
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(isMonitoringAvailableForClass:) selectorTwo:@selector(Leech_IsMonitoringAvailableForClass:)];
}

+ (void)reverseMonitoringAvailableOverride {
    [[LTTLocationManagerAuditor class] dissociateKey:LTTLocationManagerAuditorRegionClassesDictionary];
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(isMonitoringAvailableForClass:) selectorTwo:@selector(Leech_IsMonitoringAvailableForClass:)];
}

+ (void)setMonitoringAvailable:(BOOL)monitoringAvailable forClass:(Class)cls {
    NSString *className = NSStringFromClass(cls);
    NSMutableDictionary *classes = [[LTTLocationManagerAuditor class] associationForKey:LTTLocationManagerAuditorRegionClassesDictionary];
    if (!classes)
        classes = [NSMutableDictionary dictionary];
    
    if (!monitoringAvailable)
        [classes removeObjectForKey:className];
    
    else
        [classes setObject:@(YES) forKey:className];

    [[self class] associateKey:LTTLocationManagerAuditorRegionClassesDictionary withValue:[NSDictionary dictionaryWithDictionary:classes]];
}

#pragma mark Start monitoring

+ (void)auditStartMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startMonitoringForRegion:) selectorTwo:@selector(Leech_StartMonitoringForRegion:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(monitoredRegions) selectorTwo:@selector(Leech_MonitoredRegions)];
}

+ (void)stopAuditingStartMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    [locationManager dissociateKey:LTTLocationManagerAuditorRegionToStartMonitoring];
    [locationManager dissociateKey:LTTLocationManagerAuditorMonitoredRegions];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startMonitoringForRegion:) selectorTwo:@selector(Leech_StartMonitoringForRegion:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(monitoredRegions) selectorTwo:@selector(Leech_MonitoredRegions)];
}

+ (CLRegion *)regionToStartMonitoring:(CLLocationManager *)locationManager {
    return [locationManager associationForKey:LTTLocationManagerAuditorRegionToStartMonitoring];
}

#pragma mark Stop monitoring

+ (void)auditStopMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopMonitoringForRegion:) selectorTwo:@selector(Leech_StopMonitoringForRegion:)];
}

+ (void)stopAuditingStopMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    [locationManager dissociateKey:LTTLocationManagerAuditorRegionToStopMonitoring];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopMonitoringForRegion:) selectorTwo:@selector(Leech_StopMonitoringForRegion:)];
}

+ (CLRegion *)regionToStopMonitoring:(CLLocationManager *)locationManager {
    return [locationManager associationForKey:LTTLocationManagerAuditorRegionToStopMonitoring];
}

#pragma mark Monitored Regions

+ (void)setMonitoredRegions:(NSSet *)regions forLocationManager:(CLLocationManager *)locationManager {
    [locationManager associateKey:LTTLocationManagerAuditorMonitoredRegions withValue:regions];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(monitoredRegions) selectorTwo:@selector(Leech_MonitoredRegions)];
}

+ (void)clearMonitoredRegionsForLocationManager:(CLLocationManager *)locationManager {
    [locationManager dissociateKey:LTTLocationManagerAuditorMonitoredRegions];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(monitoredRegions) selectorTwo:@selector(Leech_MonitoredRegions)];
}


#pragma mark - Ranging

#pragma mark Ranging available

+ (void)overrideRangingAvailable {
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(isRangingAvailable) selectorTwo:@selector(Leech_IsRangingAvailable)];
}

+ (void)reverseRangingAvailableOverride {
    [[LTTLocationManagerAuditor class] dissociateKey:LTTLocationManagerAuditorRangingAvailableFlag];
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(isRangingAvailable) selectorTwo:@selector(Leech_IsRangingAvailable)];
}

+ (void)setRangingAvailable:(BOOL)rangingAvailable {
    [[self class] associateKey:LTTLocationManagerAuditorRangingAvailableFlag withValue:@(rangingAvailable)];
}

#pragma mark Start ranging

+ (void)auditStartRangingBeaconsInRegionMethod:(CLLocationManager *)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startRangingBeaconsInRegion:) selectorTwo:@selector(Leech_StartRangingBeaconsInRegion:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(rangedRegions) selectorTwo:@selector(Leech_RangedRegions)];
}

+ (void)stopAuditingStartRangingBeaconsInRegionMethod:(CLLocationManager *)locationManager {
    [locationManager dissociateKey:LTTLocationManagerAuditorRegionToStartRanging];
    [locationManager dissociateKey:LTTLocationManagerAuditorRangedRegions];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startRangingBeaconsInRegion:) selectorTwo:@selector(Leech_StartRangingBeaconsInRegion:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(rangedRegions) selectorTwo:@selector(Leech_RangedRegions)];
}

+ (CLBeaconRegion*)regionToStartRanging:(CLLocationManager*)locationManager {
    return [locationManager associationForKey:LTTLocationManagerAuditorRegionToStartRanging];
}

#pragma mark Stop ranging

+ (void)auditStopRangingBeaconsInRegionMethod:(CLLocationManager *)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopRangingBeaconsInRegion:) selectorTwo:@selector(Leech_StopRangingBeaconsInRegion:)];
}

+ (void)stopAuditingStopRangingBeaconsInRegionMethod:(CLLocationManager *)locationManager {
    [locationManager dissociateKey:LTTLocationManagerAuditorRegionToStopRanging];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopRangingBeaconsInRegion:) selectorTwo:@selector(Leech_StopRangingBeaconsInRegion:)];
}

+ (CLBeaconRegion*)regionToStopRanging:(CLLocationManager*)locationManager {
    return [locationManager associationForKey:LTTLocationManagerAuditorRegionToStopRanging];
}

#pragma mark Ranged Regions

+ (void)setRangedRegions:(NSSet *)regions forLocationManager:(CLLocationManager *)locationManager {
    [locationManager associateKey:LTTLocationManagerAuditorRangedRegions withValue:regions];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(rangedRegions) selectorTwo:@selector(Leech_RangedRegions)];
}

+ (void)clearRangedRegionsForLocationManager:(CLLocationManager *)locationManager {
    [locationManager dissociateKey:LTTLocationManagerAuditorRangedRegions];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(rangedRegions) selectorTwo:@selector(Leech_RangedRegions)];
}


#pragma mark - Heading

#pragma mark Heading Available

+ (void)overrideHeadingAvailable {
    [self swapHeadingAvailableMethods];
}

+ (void)reverseHeadingAvailableOverride {
    [self swapHeadingAvailableMethods];
    [self dissociateKey:LTTLocationManagerAuditorHeadingAvailableFlag];
}

+ (void)swapHeadingAvailableMethods {
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(headingAvailable) selectorTwo:@selector(Leech_HeadingAvailable)];
}

+ (void)setHeadingAvailable:(BOOL)headingAvailable {
    [self associateKey:LTTLocationManagerAuditorHeadingAvailableFlag withValue:@(headingAvailable)];
}

#pragma mark Start Updating Heading

+ (void)auditStartUpdatingHeading:(CLLocationManager *)locationManager {
    [self swapStartUpdatingHeadingMethods:locationManager];
}

+ (void)stopAuditingStartUpdatingHeading:(CLLocationManager *)locationManager {
    [self swapStartUpdatingHeadingMethods:locationManager];
    [locationManager dissociateKey:LTTLocationManagerAuditorStartUpdatingHeadingCalled];
}

+ (void)swapStartUpdatingHeadingMethods:(CLLocationManager*)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startUpdatingHeading) selectorTwo:@selector(Leech_StartUpdatingHeading)];
}

+ (BOOL)startedUpdatingHeading:(CLLocationManager *)locationManager {
    NSNumber *started = [locationManager associationForKey:LTTLocationManagerAuditorStartUpdatingHeadingCalled];
    return started.boolValue;
}

#pragma mark Stop Updating Heading

+ (void)auditStopUpdatingHeading:(CLLocationManager *)locationManager {
    [self swapStopUpdatingHeadingMethods:locationManager];
}

+ (void)stopAuditingStopUpdatingHeading:(CLLocationManager *)locationManager {
    [self swapStopUpdatingHeadingMethods:locationManager];
    [locationManager dissociateKey:LTTLocationManagerAuditorStopUpdatingHeadingCalled];
}

+ (void)swapStopUpdatingHeadingMethods:(CLLocationManager*)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopUpdatingHeading) selectorTwo:@selector(Leech_StopUpdatingHeading)];
}

+ (BOOL)stoppedUpdatingHeading:(CLLocationManager *)locationManager {
    NSNumber *stoped = [locationManager associationForKey:LTTLocationManagerAuditorStopUpdatingHeadingCalled];
    return stoped.boolValue;
}

#pragma mark Heading Override

+ (void)overrideHeading {
    [self swapHeadingAccessor];
}

+ (void)reverseHeadingOverride {
    [self swapHeadingAccessor];
}

+ (void)swapHeadingAccessor {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[CLLocationManager class] selectorOne:@selector(heading) selectorTwo:@selector(Leech_Heading)];
}

+ (void)setHeadingOverride:(CLHeading *)heading forLocationManager:(CLLocationManager *)locationManager {
    [locationManager associateKey:LTTLocationManagerAuditorHeading withValue:heading];
}

+ (void)clearHeadingOverrideForLocationManager:(CLLocationManager *)locationManager {
    [locationManager dissociateKey:LTTLocationManagerAuditorHeading];
}

@end

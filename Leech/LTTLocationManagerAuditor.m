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

const char *LTTLocationManagerAuditorRegionClassesDictionary = "LTTLocationManagerAuditorRegionClassesDictionary";
const char *LTTLocationManagerAuditorRegionToStartMonitoring = "LTTLocationManagerAuditorRegionToStartMonitoring";
const char *LTTLocationManagerAuditorRegionToStopMonitoring = "LTTLocationManagerAuditorRegionToStopMonitoring";
const char *LTTLocationManagerAuditorMonitoredRegions = "LTTLocationManagerAuditorMonitoredRegions";

const char *LTTLocationManagerAuditorRangingAvailableFlag = "LTTLocationManagerAuditorRangingAvailableFlag";
const char *LTTLocationManagerAuditorRegionToStartRanging = "LTTLocationManagerAuditorRegionToStartRanging";
const char *LTTLocationManagerAuditorRegionToStopRanging = "LTTLocationManagerAuditorRegionToStopRanging";
const char *LTTLocationManagerAuditorRangedRegions = "LTTLocationManagerAuditorRangedRegions";


////////////////////////////////////////////////////////////////////////////////
//  Category on CLLocationManager
////////////////////////////////////////////////////////////////////////////////

@implementation CLLocationManager (Leech)

#pragma mark - Region monitoring

+ (BOOL)Leech_IsMonitoringAvailableForClass:(Class)regionClass {
    NSDictionary *classes = objc_getAssociatedObject([LTTLocationManagerAuditor class], LTTLocationManagerAuditorRegionClassesDictionary);
    NSNumber *monitoringAvailable = classes[NSStringFromClass([regionClass class])];
    return monitoringAvailable.boolValue;
}

- (void)Leech_StartMonitoringForRegion:(CLRegion *)region {
    objc_setAssociatedObject(self, LTTLocationManagerAuditorRegionToStartMonitoring, region, OBJC_ASSOCIATION_RETAIN);
    NSSet *monitoredRegions = [NSSet setWithObject:region];
    objc_setAssociatedObject(self, LTTLocationManagerAuditorMonitoredRegions, monitoredRegions, OBJC_ASSOCIATION_RETAIN);
}

- (void)Leech_StopMonitoringForRegion:(CLRegion *)region {
    objc_setAssociatedObject(self, LTTLocationManagerAuditorRegionToStopMonitoring, region, OBJC_ASSOCIATION_RETAIN);
}

- (NSSet *)Leech_MonitoredRegions {
    return objc_getAssociatedObject(self, LTTLocationManagerAuditorMonitoredRegions);
}

#pragma mark - Beacon ranging

+ (BOOL)Leech_IsRangingAvailable {
    NSNumber *rangingAvailable = objc_getAssociatedObject([LTTLocationManagerAuditor class], LTTLocationManagerAuditorRangingAvailableFlag);
    return rangingAvailable.boolValue;
}

- (void)Leech_StartRangingBeaconsInRegion:(CLBeaconRegion *)region {
    objc_setAssociatedObject(self, LTTLocationManagerAuditorRegionToStartRanging, region, OBJC_ASSOCIATION_RETAIN);
    NSSet *rangedRegions = [NSSet setWithObject:region];
    objc_setAssociatedObject(self, LTTLocationManagerAuditorRangedRegions, rangedRegions, OBJC_ASSOCIATION_RETAIN);
}

- (void)Leech_StopRangingBeaconsInRegion:(CLBeaconRegion *)region {
    objc_setAssociatedObject(self, LTTLocationManagerAuditorRegionToStopRanging, region, OBJC_ASSOCIATION_RETAIN);
}

- (NSSet *)Leech_RangedRegions {
    return objc_getAssociatedObject(self, LTTLocationManagerAuditorRangedRegions);
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
    objc_setAssociatedObject([LTTLocationManagerAuditor class], LTTLocationManagerAuditorRegionClassesDictionary, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(isMonitoringAvailableForClass:) selectorTwo:@selector(Leech_IsMonitoringAvailableForClass:)];
}

+ (void)setMonitoringAvailable:(BOOL)monitoringAvailable forClass:(Class)cls {
    NSString *className = NSStringFromClass(cls);
    NSMutableDictionary *classes = objc_getAssociatedObject([LTTLocationManagerAuditor class], LTTLocationManagerAuditorRegionClassesDictionary);
    if (!classes)
        classes = [NSMutableDictionary dictionary];
    
    if (!monitoringAvailable)
        [classes removeObjectForKey:className];
    
    else
        [classes setObject:@(YES) forKey:className];
    
    objc_setAssociatedObject(self, LTTLocationManagerAuditorRegionClassesDictionary, [NSDictionary dictionaryWithDictionary:classes], OBJC_ASSOCIATION_RETAIN);
}

#pragma mark Start monitoring

+ (void)auditStartMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startMonitoringForRegion:) selectorTwo:@selector(Leech_StartMonitoringForRegion:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(monitoredRegions) selectorTwo:@selector(Leech_MonitoredRegions)];
}

+ (void)stopAuditingStartMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    objc_setAssociatedObject(locationManager, LTTLocationManagerAuditorRegionToStartMonitoring, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(locationManager, LTTLocationManagerAuditorMonitoredRegions, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startMonitoringForRegion:) selectorTwo:@selector(Leech_StartMonitoringForRegion:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(monitoredRegions) selectorTwo:@selector(Leech_MonitoredRegions)];
}

+ (CLRegion *)regionToStartMonitoring:(CLLocationManager *)locationManager {
    return objc_getAssociatedObject(locationManager, LTTLocationManagerAuditorRegionToStartMonitoring);
}

#pragma mark Stop monitoring

+ (void)auditStopMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopMonitoringForRegion:) selectorTwo:@selector(Leech_StopMonitoringForRegion:)];
}

+ (void)stopAuditingStopMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    objc_setAssociatedObject(locationManager, LTTLocationManagerAuditorRegionToStopMonitoring, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopMonitoringForRegion:) selectorTwo:@selector(Leech_StopMonitoringForRegion:)];
}

+ (CLRegion *)regionToStopMonitoring:(CLLocationManager *)locationManager {
    return objc_getAssociatedObject(locationManager, LTTLocationManagerAuditorRegionToStopMonitoring);
}

#pragma mark Monitored Regions

+ (void)setMonitoredRegions:(NSSet *)regions forLocationManager:(CLLocationManager *)locationManager {
    objc_setAssociatedObject(locationManager, LTTLocationManagerAuditorMonitoredRegions, regions, OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(monitoredRegions) selectorTwo:@selector(Leech_MonitoredRegions)];
}

+ (void)clearMonitoredRegionsForLocationManager:(CLLocationManager *)locationManager {
    objc_setAssociatedObject(locationManager, LTTLocationManagerAuditorMonitoredRegions, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(monitoredRegions) selectorTwo:@selector(Leech_MonitoredRegions)];
}


#pragma mark - Ranging

#pragma mark Ranging available

+ (void)overrideRangingAvailable {
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(isRangingAvailable) selectorTwo:@selector(Leech_IsRangingAvailable)];
}

+ (void)reverseRangingAvailableOverride {
    objc_setAssociatedObject([LTTLocationManagerAuditor class], LTTLocationManagerAuditorRangingAvailableFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(isRangingAvailable) selectorTwo:@selector(Leech_IsRangingAvailable)];
}

+ (void)setRangingAvailable:(BOOL)rangingAvailable {
    objc_setAssociatedObject(self, LTTLocationManagerAuditorRangingAvailableFlag, @(rangingAvailable), OBJC_ASSOCIATION_RETAIN);
}

#pragma mark Start ranging

+ (void)auditStartRangingBeaconsInRegionMethod:(CLLocationManager *)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startRangingBeaconsInRegion:) selectorTwo:@selector(Leech_StartRangingBeaconsInRegion:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(rangedRegions) selectorTwo:@selector(Leech_RangedRegions)];
}

+ (void)stopAuditingStartRangingBeaconsInRegionMethod:(CLLocationManager *)locationManager {
    objc_setAssociatedObject(locationManager, LTTLocationManagerAuditorRegionToStartRanging, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(locationManager, LTTLocationManagerAuditorRangedRegions, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startRangingBeaconsInRegion:) selectorTwo:@selector(Leech_StartRangingBeaconsInRegion:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(rangedRegions) selectorTwo:@selector(Leech_RangedRegions)];
}

+ (CLBeaconRegion*)regionToStartRanging:(CLLocationManager*)locationManager {
    return objc_getAssociatedObject(locationManager, LTTLocationManagerAuditorRegionToStartRanging);
}

#pragma mark Stop ranging

+ (void)auditStopRangingBeaconsInRegionMethod:(CLLocationManager *)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopRangingBeaconsInRegion:) selectorTwo:@selector(Leech_StopRangingBeaconsInRegion:)];
}

+ (void)stopAuditingStopRangingBeaconsInRegionMethod:(CLLocationManager *)locationManager {
    objc_setAssociatedObject(locationManager, LTTLocationManagerAuditorRegionToStopRanging, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopRangingBeaconsInRegion:) selectorTwo:@selector(Leech_StopRangingBeaconsInRegion:)];
}

+ (CLBeaconRegion*)regionToStopRanging:(CLLocationManager*)locationManager {
    return objc_getAssociatedObject(locationManager, LTTLocationManagerAuditorRegionToStopRanging);
}

#pragma mark Ranged Regions

+ (void)setRangedRegions:(NSSet *)regions forLocationManager:(CLLocationManager *)locationManager {
    objc_setAssociatedObject(locationManager, LTTLocationManagerAuditorRangedRegions, regions, OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(rangedRegions) selectorTwo:@selector(Leech_RangedRegions)];
}

+ (void)clearRangedRegionsForLocationManager:(CLLocationManager *)locationManager {
    objc_setAssociatedObject(locationManager, LTTLocationManagerAuditorRangedRegions, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(rangedRegions) selectorTwo:@selector(Leech_RangedRegions)];
}

@end

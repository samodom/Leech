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

const char *RegionClassesDictionary = "RegionClassesDictionary";
const char *RegionToStartMonitoring = "RegionToStartMonitoring";
const char *RegionToStopMonitoring = "RegionToStopMonitoring";

const char *RangingAvailableFlag = "RangingAvailableFlag";

////////////////////////////////////////////////////////////////////////////////
//  Category on CLLocationManager
////////////////////////////////////////////////////////////////////////////////

@implementation CLLocationManager (Leech)

+ (BOOL)Leech_IsMonitoringAvailableForClass:(Class)regionClass {
    NSDictionary *classes = objc_getAssociatedObject([LTTLocationManagerAuditor class], RegionClassesDictionary);
    NSNumber *monitoringAvailable = classes[NSStringFromClass([regionClass class])];
    return monitoringAvailable.boolValue;
}

+ (BOOL)Leech_IsRangingAvailable {
    NSNumber *rangingAvailable = objc_getAssociatedObject([LTTLocationManagerAuditor class], RangingAvailableFlag);
    return rangingAvailable.boolValue;
}

- (void)Leech_StartMonitoringForRegion:(CLRegion *)region {
    objc_setAssociatedObject(self, RegionToStartMonitoring, region, OBJC_ASSOCIATION_RETAIN);
}

- (void)Leech_StopMonitoringForRegion:(CLRegion *)region {
    objc_setAssociatedObject(self, RegionToStopMonitoring, region, OBJC_ASSOCIATION_RETAIN);
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
    objc_setAssociatedObject([LTTLocationManagerAuditor class], RegionClassesDictionary, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(isMonitoringAvailableForClass:) selectorTwo:@selector(Leech_IsMonitoringAvailableForClass:)];
}

+ (void)setMonitoringAvailable:(BOOL)monitoringAvailable forClass:(Class)cls {
    NSString *className = NSStringFromClass(cls);
    NSMutableDictionary *classes = objc_getAssociatedObject([LTTLocationManagerAuditor class], RegionClassesDictionary);
    if (!classes)
        classes = [NSMutableDictionary dictionary];
    
    if (!monitoringAvailable)
        [classes removeObjectForKey:className];
    
    else
        [classes setObject:@(YES) forKey:className];
    
    objc_setAssociatedObject(self, RegionClassesDictionary, [NSDictionary dictionaryWithDictionary:classes], OBJC_ASSOCIATION_RETAIN);
}

#pragma mark Start monitoring

+ (void)auditStartMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startMonitoringForRegion:) selectorTwo:@selector(Leech_StartMonitoringForRegion:)];
}

+ (void)stopAuditingStartMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    objc_setAssociatedObject(locationManager, RegionToStartMonitoring, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(startMonitoringForRegion:) selectorTwo:@selector(Leech_StartMonitoringForRegion:)];
}

+ (CLRegion *)regionToStartMonitoring:(CLLocationManager *)locationManager {
    return objc_getAssociatedObject(locationManager, RegionToStartMonitoring);
}

#pragma mark Stop monitoring

+ (void)auditStopMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopMonitoringForRegion:) selectorTwo:@selector(Leech_StopMonitoringForRegion:)];
}

+ (void)stopAuditingStopMonitoringForRegionMethod:(CLLocationManager*)locationManager {
    objc_setAssociatedObject(locationManager, RegionToStopMonitoring, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[locationManager class] selectorOne:@selector(stopMonitoringForRegion:) selectorTwo:@selector(Leech_StopMonitoringForRegion:)];
}

+ (CLRegion *)regionToStopMonitoring:(CLLocationManager *)locationManager {
    return objc_getAssociatedObject(locationManager, RegionToStopMonitoring);
}

#pragma mark - Ranging

+ (void)overrideRangingAvailable {
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(isRangingAvailable) selectorTwo:@selector(Leech_IsRangingAvailable)];
}

+ (void)reverseRangingAvailableOverride {
    objc_setAssociatedObject([LTTLocationManagerAuditor class], RangingAvailableFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapClassMethodsForClass:[CLLocationManager class] selectorOne:@selector(isRangingAvailable) selectorTwo:@selector(Leech_IsRangingAvailable)];
}

+ (void)setRangingAvailable:(BOOL)rangingAvailable {
    objc_setAssociatedObject(self, RangingAvailableFlag, @(rangingAvailable), OBJC_ASSOCIATION_RETAIN);
}


@end

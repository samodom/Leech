//
//  LTTLocationManagerAuditor.h
//  Leech
//
//  Created by Sam Odom on 4/22/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTLocationManagerAuditor : NSObject

#pragma mark - Region monitoring

+ (void)overrideMonitoringAvailable;
+ (void)reverseMonitoringAvailableOverride;
+ (void)setMonitoringAvailable:(BOOL)monitoringAvailable forClass:(Class)cls;

+ (void)auditStartMonitoringForRegionMethod:(CLLocationManager*)locationManager;
+ (void)stopAuditingStartMonitoringForRegionMethod:(CLLocationManager*)locationManager;
+ (CLRegion*)regionToStartMonitoring:(CLLocationManager*)locationManager;

+ (void)auditStopMonitoringForRegionMethod:(CLLocationManager*)locationManager;
+ (void)stopAuditingStopMonitoringForRegionMethod:(CLLocationManager*)locationManager;
+ (CLRegion*)regionToStopMonitoring:(CLLocationManager*)locationManager;

#pragma mark - Ranging

+ (void)overrideRangingAvailable;
+ (void)reverseRangingAvailableOverride;
+ (void)setRangingAvailable:(BOOL)rangingAvailable;


@end

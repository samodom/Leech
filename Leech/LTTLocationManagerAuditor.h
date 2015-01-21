//
//  LTTLocationManagerAuditor.h
//  Leech
//
//  Created by Sam Odom on 4/22/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTLocationManagerAuditor : NSObject

/**
 LTTLocationManagerAuditor assists in the testing of CLLocationManager usage and operations.
 */

#pragma mark - Region monitoring

/**
 Overrides the method that checks for the ability to perform monitoring of particular region types so that the simulator can be used for testing.
 
 @discussion This method replaces the real method implementation of `-[CLLocationManager isMonitoringAvailableForClass:]` with another method that uses the custom-supplied return value
 */
+ (void)overrideMonitoringAvailable;

/**
 Reverses the overriding of the method that checks for the ability to perform monitoring of particular region types
 */
+ (void)reverseMonitoringAvailableOverride;

/**
 Sets the availability of region monitoring for particular region types
 
 @param monitoringAvailable BOOL value indicating whether or not monitoring should be considered available
 @param cls Class for which to consider monitoring available or unavailable
 */
+ (void)setMonitoringAvailable:(BOOL)monitoringAvailable forClass:(Class)cls;


/**
 Audits calls to start monitoring regions
 
 @param locationManager CLLocationManager object to audit for region monitoring calls
 
 @discussion This method replaces the real method implementation of `-[CLLocationManager startMonitoringForRegion:]` with another method that captures the call to start monitoring as well as the region argument
 */
+ (void)auditStartMonitoringForRegionMethod:(CLLocationManager*)locationManager;

/**
 Ends auditing of calls to start monitoring regions
 
 @param locationManager Location manager being audited
 */
+ (void)stopAuditingStartMonitoringForRegionMethod:(CLLocationManager*)locationManager;

/**
 Retrieves the region the location manager is expected to start monitoring
 
 @return CLRegion The region the location manager was asked to start monitoring
 
 @param locationManager Location manager being audited
 */
+ (CLRegion*)regionToStartMonitoring:(CLLocationManager*)locationManager;

/**
 Audits calls to stop monitoring regions
 
 @param locationManager CLLocationManager object to audit for region monitoring calls
 
 @discussion This method replaces the real method implementation of `-[CLLocationManager stopMonitoringForRegion:]` with another method that captures the call to stop monitoring as well as the region argument
 */
+ (void)auditStopMonitoringForRegionMethod:(CLLocationManager*)locationManager;

/**
 Ends auditing of calls to stop monitoring regions
 
 @param locationManager Location manager being audited
 */
+ (void)stopAuditingStopMonitoringForRegionMethod:(CLLocationManager*)locationManager;

/**
 Retrieves the region the location manager is expected to stop monitoring
 
 @return CLRegion The region the location manager was asked to stop monitoring
 
 @param locationManager Location manager being audited
 */
+ (CLRegion*)regionToStopMonitoring:(CLLocationManager*)locationManager;

/**
 Sets the regions considered to be monitored for the location manager
 
 @param regions NSSet of regions to be considered monitored by the location manager
 @param locationManager Location manager being audited
 */
+ (void)setMonitoredRegions:(NSSet*)regions forLocationManager:(CLLocationManager*)locationManager;

/**
 Clears the monitored regions for the location manager that were set with `[LTTLocationManagerAuditor setMonitoredRegions:forLocationManager:]`
 
 @param locationManager Location manager being audited
 */
+ (void)clearMonitoredRegionsForLocationManager:(CLLocationManager*)locationManager;


#pragma mark - Ranging

/**
 Overrides the method that checks for the ability to perform ranging of beacons so that the simulator can be used for testing.
 
 @discussion This method replaces the real method implementation of `-[CLLocationManager isRangingAvailable]` with another method that uses the custom-supplied return value
 */
+ (void)overrideRangingAvailable;

/**
 Reverses the overriding of the method that checks for the ability to perform ranging of beacons
 */
+ (void)reverseRangingAvailableOverride;

/**
 Sets the availability of beacon ranging
 
 @param rangingAvailable BOOL value indicating whether or not beacon ranging should be considered available
 */
+ (void)setRangingAvailable:(BOOL)rangingAvailable;

/**
 Audits calls to start ranging beacons
 
 @param locationManager CLLocationManager object to audit for beacon ranging calls
 
 @discussion This method replaces the real method implementation of `-[CLLocationManager startRangingBeaconsInRegion:]` with another method that captures the call to start ranging as well as the beacon region argument
 */
+ (void)auditStartRangingBeaconsInRegionMethod:(CLLocationManager*)locationManager;

/**
 Ends auditing of calls to start ranging beacons
 
 @param locationManager Location manager being audited
 */
+ (void)stopAuditingStartRangingBeaconsInRegionMethod:(CLLocationManager*)locationManager;

/**
 Retrieves the region the location manager is expected to start ranging
 
 @return CLBeaconRegion The beacon region the location manager was asked to start ranging
 
 @param locationManager Location manager being audited
 */
+ (CLBeaconRegion*)regionToStartRanging:(CLLocationManager*)locationManager;

/**
 Audits calls to stop ranging beacon regions
 
 @param locationManager CLLocationManager object to audit for beacon ranging calls
 
 @discussion This method replaces the real method implementation of `-[CLLocationManager stopRangingBeaconsInRegion:]` with another method that captures the call to stop ranging as well as the beacon region argument
 */
+ (void)auditStopRangingBeaconsInRegionMethod:(CLLocationManager*)locationManager;

/**
 Ends auditing of calls to stop ranging beacon regions
 
 @param locationManager Location manager being audited
 */
+ (void)stopAuditingStopRangingBeaconsInRegionMethod:(CLLocationManager*)locationManager;

/**
 Retrieves the beacon region the location manager is expected to stop ranging
 
 @return CLBeaconRegion The beacon region the location manager was asked to stop ranging
 
 @param locationManager Location manager being audited
 */
+ (CLBeaconRegion*)regionToStopRanging:(CLLocationManager*)locationManager;

/**
 Sets the regions considered to be ranged for the location manager
 
 @param regions NSSet of beacon regions to be considered ranged by the location manager
 @param locationManager Location manager being audited
 */
+ (void)setRangedRegions:(NSSet*)regions forLocationManager:(CLLocationManager*)locationManager;

/**
 Clears the monitored regions for the location manager that were set with `[LTTLocationManagerAuditor setRangedRegions:forLocationManager:]`
 
 @param locationManager Location manager being audited
 */
+ (void)clearRangedRegionsForLocationManager:(CLLocationManager*)locationManager;


#pragma mark - Heading

/**
 Overrides the method that checks for heading availability so that the simulator can be used for testing.

 @discussion This method replaces the real method implementation of `-[CLLocationManager headingAvailable]` with another method that uses the custom-supplied return value
 */
+ (void)overrideHeadingAvailable;

/**
 Reverses the overriding of the method that checks for heading availability.
 */
+ (void)reverseHeadingAvailableOverride;

/**
 Sets the heading availability.

 @param headingAvailable BOOL value indicating whether or not headings should be considered available
 */
+ (void)setHeadingAvailable:(BOOL)headingAvailable;

/**
 Audits calls to start updating the heading

 @param locationManager CLLocationManager object to audit for start updating heading calls

 @discussion This method replaces the real method implementation of `-[CLLocationManager startUpdatingHeading]` with another method that captures the call to the method.
 */
+ (void)auditStartUpdatingHeading:(CLLocationManager*)locationManager;

/**
 Ends auditing of calls to start updating heading

 @param locationManager Location manager being audited
 */
+ (void)stopAuditingStartUpdatingHeading:(CLLocationManager*)locationManager;

/**
 Indicates that `startUpdatingHeading` was called on the supplied location manager.
 
 @param locationManager The location manager being audited.
 */
+ (BOOL)startedUpdatingHeading:(CLLocationManager*)locationManager;

/**
 Audits calls to stop updating the heading

 @param locationManager CLLocationManager object to audit for stop updating heading calls

 @discussion This method replaces the real method implementation of `-[CLLocationManager stopUpdatingHeading]` with another method that captures the call to the method
 */
+ (void)auditStopUpdatingHeading:(CLLocationManager*)locationManager;

/**
 Ends auditing of calls to stop updating heading

 @param locationManager Location manager being audited
 */
+ (void)stopAuditingStopUpdatingHeading:(CLLocationManager*)locationManager;

/**
 Indicates that `stopUpdatingHeading` was called on the supplied location manager.

 @param locationManager The location manager being audited.
 */
+ (BOOL)stoppedUpdatingHeading:(CLLocationManager*)locationManager;

/**
 Overrides the property accessors for `heading` on a location manager.
*/
+ (void)overrideHeading;

/**
 Stops overriding the property accessors for `heading` on a provided location manager.
 */
+ (void)reverseHeadingOverride;

/**
 Sets the heading to be returned by the location manager

 @param heading CLHeading object to be used the by location manager.  You can create a mutable heading using the `LTTMockHeading` class.
 @param locationManager Location manager with the overriden property
 */
+ (void)setHeadingOverride:(CLHeading*)heading forLocationManager:(CLLocationManager*)locationManager;

/**
 Clears the overriden heading that was set with `[LTTLocationManagerAuditor setHeadingOverride:forLocationManager:]`

 @param locationManager Location manager with the overriden property
 */
+ (void)clearHeadingOverrideForLocationManager:(CLLocationManager*)locationManager;

@end

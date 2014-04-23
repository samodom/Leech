//
//  LTTMockBeacon.h
//  Leech
//
//  Created by Sam Odom on 4/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LTTMockBeacon : NSObject

@property (strong) NSUUID *proximityUUID;
@property (strong) NSNumber *major;
@property (strong) NSNumber *minor;

@property CLProximity proximity;
@property CLLocationAccuracy accuracy;
@property NSInteger rssi;

- (instancetype)initWithProximityUUID:(NSUUID*)proximityUUID major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor;

@end

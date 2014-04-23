//
//  LTTMockBeacon.m
//  Leech
//
//  Created by Sam Odom on 4/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTMockBeacon.h"

@implementation LTTMockBeacon

- (instancetype)initWithProximityUUID:(NSUUID *)proximityUUID major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor {
    if (self = [super init]) {
        _proximityUUID = proximityUUID;
        _major = @(major);
        _minor = @(minor);
    }
    
    return self;
}

@end

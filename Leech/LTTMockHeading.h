//
//  LTTMockHeading.h
//  Leech
//
//  Created by Sam Odom on 1/21/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface LTTMockHeading : CLHeading

@property(nonatomic) CLLocationDirection magneticHeading;

@property(nonatomic) CLLocationDirection trueHeading;

@property(nonatomic) CLLocationDirection headingAccuracy;

@property(nonatomic, copy) NSDate *timestamp;

@property(nonatomic, copy) NSString *description;

@property(nonatomic) CLHeadingComponentValue x;
@property(nonatomic) CLHeadingComponentValue y;
@property(nonatomic) CLHeadingComponentValue z;



@end

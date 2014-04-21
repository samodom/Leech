//
//  LTTMockUserLocation.h
//  Leech
//
//  Created by Sam Odom on 3/15/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

/**
 Mock object representing an MKUserLocation
 */
@interface LTTMockUserLocation : NSObject

/** Represents the CLLocation object for this object */
@property (strong) CLLocation *location;

@end

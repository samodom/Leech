//
//  LTTMockMapView.h
//  Leech
//
//  Created by Sam Odom on 3/15/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 Mock object representing a UIMapView
 */
@interface LTTMockMapView : NSObject

/** Represents a user-specified location instead of relying on the actual location services */
@property (strong) MKUserLocation *userLocation;

/** Represents a user-specified region of the map */
@property MKCoordinateRegion region;

@end

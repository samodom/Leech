//
//  LTTMockMapView.h
//  Leech
//
//  Created by Sam Odom on 3/15/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LTTMockMapView : NSObject

@property (strong) MKUserLocation *userLocation;
@property MKCoordinateRegion region;

@end

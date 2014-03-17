//
//  LTTMapViewAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/15/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LTTMapViewAuditor : NSObject

#pragma mark -showAnnotations:animated:

+ (void)auditShowAnnotationsMethod:(MKMapView*)mapView forward:(BOOL)forward;
+ (void)stopAuditingShowAnnotationsMethod:(MKMapView*)auditedMapView;
+ (NSArray*)annotationsToShow:(MKMapView*)auditedMapView;
+ (BOOL)showAnnotationsAnimatedFlag:(MKMapView*)auditedMapView;

#pragma mark -selectAnnotation:animated:

+ (void)auditSelectAnnotationMethod:(MKMapView*)mapView forward:(BOOL)forward;
+ (void)stopAuditingSelectAnnotationMethod:(MKMapView*)auditedMapView;
+ (id<MKAnnotation>)annotationToSelect:(MKMapView*)auditedMapView;
+ (BOOL)selectAnnotationAnimatedFlag:(MKMapView*)auditedMapView;

@end

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

/**
 LTTMapViewAuditor assists in the testing of MKMapKit annotation display and selection
 */

#pragma mark -showAnnotations:animated:

/**
 Audits calls to show annotations on a map view
 
 @param mapView MKMapView object to be audited for calls to show annotations
 @param forward BOOL value indicating whether or not the method call should be forwarded to the true method after auditing
 
 @discussion This method replaces the real method implementation of `-[MKMapView showAnnotations:animated:]` with another method that captures the call to show annotations and optionally forwards the call to the real method implementation
 */
+ (void)auditShowAnnotationsMethod:(MKMapView*)mapView forward:(BOOL)forward;

/**
 Ends auditing of `showAnnotations:animated:` and clears captured data
 
 @param auditedMapView Map view being audited
 */
+ (void)stopAuditingShowAnnotationsMethod:(MKMapView*)auditedMapView;

/**
 Retrieves the annotations to show on the map that were captured
 
 @return NSArray of annotations that were to be shown on the map view
 
 @param auditedMapView Map view being audited
 */
+ (NSArray*)annotationsToShow:(MKMapView*)auditedMapView;

/**
 Indicates whether or not the call to show annotations was animated
 
 @return BOOL value indicating whether or not the annotation display was to be animated
 
 @param auditedMapView Map view being audited
 */
+ (BOOL)showAnnotationsAnimatedFlag:(MKMapView*)auditedMapView;

#pragma mark -selectAnnotation:animated:

/**
 Audits calls to select an annotation on a map view
 
 @param mapView MKMapView object to be audited for calls to select an annotation
 @param forward BOOL value indicating whether or not the method call should be forwarded to the true method after auditing
 
 @discussion This method replaces the real method implementation of `-[MKMapView selectAnnotation:animated:]` with another method that captures the call to show an annotation and optionally forwards the call to the real method implementation
 */
+ (void)auditSelectAnnotationMethod:(MKMapView*)mapView forward:(BOOL)forward;

/**
 Ends auditing of `selectAnnotation:animated:` and clears captured data
 
 @param auditedMapView Map view being audited
 */
+ (void)stopAuditingSelectAnnotationMethod:(MKMapView*)auditedMapView;

/**
 Retrieves the annotation to select on the map that was captured
 
 @return Map annotation that was to be selected on the map view
 
 @param auditedMapView Map view being audited
 */
+ (id<MKAnnotation>)annotationToSelect:(MKMapView*)auditedMapView;

/**
 Indicates whether or not the call to select an annotation was animated
 
 @return BOOL value indicating whether or not the annotation selection was to be animated
 
 @param auditedMapView Map view being audited
 */
+ (BOOL)selectAnnotationAnimatedFlag:(MKMapView*)auditedMapView;

@end

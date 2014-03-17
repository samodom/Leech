//
//  LTTMapViewAuditor.m
//  Leech
//
//  Created by Sam Odom on 3/15/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTMapViewAuditor.h"

#import "LTTMethodSwizzler.h"

const char *ShouldForwardShowAnnotationsMethod = "ShouldForwardShowAnnotationsMethod";
const char *AnnotationsToShow = "AnnotationsToShow";
const char *ShowAnnotationsAnimatedFlag = "ShowAnnotationsAnimatedFlag";

const char *ShouldForwardSelectAnnotationMethod = "ShouldForwardSelectAnnotationMethod";
const char *AnnotationToSelect = "AnnotationToSelect";
const char *SelectAnnotationAnimatedFlag = "SelectAnnotationAnimatedFlag";

////////////////////////////////////////////////////////////////////////////////
//  Cateogry on MKMapView
////////////////////////////////////////////////////////////////////////////////

@implementation MKMapView (Leech)

- (void)Leech_ShowAnnotations:(NSArray *)annotations animated:(BOOL)animated {
    objc_setAssociatedObject(self, AnnotationsToShow, annotations, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, ShowAnnotationsAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardShowAnnotationsMethod);
    if (forward.boolValue)
        [self Leech_ShowAnnotations:annotations animated:animated];
}

- (void)Leech_SelectAnnotation:(id<MKAnnotation>)annotation animated:(BOOL)animated {
    objc_setAssociatedObject(self, AnnotationToSelect, annotation, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, SelectAnnotationAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardSelectAnnotationMethod);
    if (forward.boolValue)
        [self Leech_SelectAnnotation:annotation animated:animated];
}

@end

////////////////////////////////////////////////////////////////////////////////
//  Map View Auditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTMapViewAuditor

#pragma mark -showAnnotations:animated:

+ (void)auditShowAnnotationsMethod:(MKMapView *)mapView forward:(BOOL)forward {
    objc_setAssociatedObject(mapView, ShouldForwardShowAnnotationsMethod, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[mapView class] selectorOne:@selector(showAnnotations:animated:) selectorTwo:@selector(Leech_ShowAnnotations:animated:)];
}

+ (void)stopAuditingShowAnnotationsMethod:(MKMapView *)auditedMapView {
    objc_setAssociatedObject(auditedMapView, ShouldForwardShowAnnotationsMethod, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedMapView, AnnotationsToShow, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedMapView, ShowAnnotationsAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[auditedMapView class] selectorOne:@selector(showAnnotations:animated:) selectorTwo:@selector(Leech_ShowAnnotations:animated:)];
}

+ (NSArray *)annotationsToShow:(MKMapView *)auditedMapView {
    return objc_getAssociatedObject(auditedMapView, AnnotationsToShow);
}

+ (BOOL)showAnnotationsAnimatedFlag:(MKMapView *)auditedMapView {
    NSNumber *animated = objc_getAssociatedObject(auditedMapView, ShowAnnotationsAnimatedFlag);
    return animated.boolValue;
}

#pragma mark -selectAnnotation:animated:

+ (void)auditSelectAnnotationMethod:(MKMapView *)mapView forward:(BOOL)forward {
    objc_setAssociatedObject(mapView, ShouldForwardSelectAnnotationMethod, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[mapView class] selectorOne:@selector(selectAnnotation:animated:) selectorTwo:@selector(Leech_SelectAnnotation:animated:)];
}

+ (void)stopAuditingSelectAnnotationMethod:(MKMapView *)auditedMapView {
    objc_setAssociatedObject(auditedMapView, ShouldForwardSelectAnnotationMethod, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedMapView, AnnotationToSelect, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedMapView, SelectAnnotationAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[auditedMapView class] selectorOne:@selector(selectAnnotation:animated:) selectorTwo:@selector(Leech_SelectAnnotation:animated:)];
}

+ (id<MKAnnotation>)annotationToSelect:(MKMapView *)auditedMapView {
    return objc_getAssociatedObject(auditedMapView, AnnotationToSelect);
}

+ (BOOL)selectAnnotationAnimatedFlag:(MKMapView *)auditedMapView {
    NSNumber *animated = objc_getAssociatedObject(auditedMapView, SelectAnnotationAnimatedFlag);
    return animated.boolValue;
}

@end

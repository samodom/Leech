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

@end

////////////////////////////////////////////////////////////////////////////////
//  Map View Auditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTMapViewAuditor

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

@end

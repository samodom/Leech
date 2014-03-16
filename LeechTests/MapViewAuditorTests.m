//
//  MapViewAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 3/15/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MapKit/MapKit.h>

//  Mocks+
#import "TestMapAnnotation.h"

//  Production
#import "LTTMapViewAuditor.h"

@interface MapViewAuditorTests : XCTestCase

@end

@implementation MapViewAuditorTests {
    MKMapView *mapView;
}

- (void)setUp {
    [super setUp];

    mapView = [MKMapView new];
}

- (void)tearDown {
    mapView = nil;

    [super tearDown];
}

- (void)testAuditingOfShowAnnotationsMethod {
    NSArray *annotations = @[[TestMapAnnotation new], [TestMapAnnotation new]];
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([mapView class], @selector(showAnnotations:animated:)));
    [LTTMapViewAuditor auditShowAnnotationsMethod:mapView forward:YES];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([mapView class], @selector(showAnnotations:animated:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [mapView showAnnotations:annotations animated:YES];
    XCTAssertEqualObjects([LTTMapViewAuditor annotationsToShow:mapView], annotations, @"The annotations to show should be captured");
    XCTAssertTrue([LTTMapViewAuditor showAnnotationsAnimatedFlag:mapView], @"The animated flag should have been audited");
    [LTTMapViewAuditor stopAuditingShowAnnotationsMethod:mapView];
    currentImplementation = method_getImplementation(class_getInstanceMethod([mapView class], @selector(showAnnotations:animated:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end

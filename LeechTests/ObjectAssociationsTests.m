//
//  ObjectAssociationsTests.m
//  PWTesting
//
//  Created by Sam Odom on 8/31/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

#import "NSObject+Association.h"

static const char *SampleAssociationKey = "SampleAssociationKey";

@interface ObjectAssociationsTests : XCTestCase

@end

@implementation ObjectAssociationsTests {
    NSObject *sampleObject;
    NSObject *sampleAssociation;
}

- (void)setUp {
    [super setUp];
    
    sampleObject = [NSObject new];
    sampleAssociation = [NSObject new];
}

- (void)tearDown {
    sampleObject = nil;
    sampleAssociation = nil;
    
    [super tearDown];
}

- (void)testSettingOfRetainedAssociatedObject {
    [sampleObject associateKey:SampleAssociationKey withValue:sampleAssociation];
    NSObject *association = objc_getAssociatedObject(sampleObject, SampleAssociationKey);
    XCTAssertEqualObjects(association, sampleAssociation, @"The object should have been associated with the test object");
    sampleAssociation = nil;
    association = objc_getAssociatedObject(sampleObject, SampleAssociationKey);
    XCTAssertNotNil(association, @"The object should be retained");
}

- (void)testRetrievalOfAssocation {
    objc_setAssociatedObject(sampleObject, SampleAssociationKey, sampleAssociation, OBJC_ASSOCIATION_RETAIN);
    NSObject *association = [sampleObject associationForKey:SampleAssociationKey];
    XCTAssertEqualObjects(association, sampleAssociation, @"The association should be retreived with the key");
}

- (void)testClearingOfRetainedAssociatedObject {
    objc_setAssociatedObject(sampleObject, SampleAssociationKey, sampleAssociation, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(sampleObject, "another key", [NSObject new], OBJC_ASSOCIATION_RETAIN);
    NSObject *association = [sampleObject dissociateKey:SampleAssociationKey];
    XCTAssertEqualObjects(association, sampleAssociation, @"The associated object should be returned from dissociation");
    association = objc_getAssociatedObject(sampleObject, SampleAssociationKey);
    XCTAssertNil(association, @"The association should be cleared");
    association = objc_getAssociatedObject(sampleObject, "another key");
    XCTAssertNotNil(association, @"Other existing associations should be maintained");
}

@end

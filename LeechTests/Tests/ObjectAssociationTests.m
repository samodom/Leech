//
//  ObjectAssociationTests.m
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSObject+ObjectAssociation.h"

#import "SampleAssociatedObject.h"

const char * ObjectAssociationTestsSampleKey = "ObjectAssociationTestsSampleKey";
const char * ObjectAssociationTestsExtraKey = "ObjectAssociationTestsExtraKey";

@interface ObjectAssociationTests : XCTestCase

@end

@implementation ObjectAssociationTests {
    NSObject *object;
    SampleAssociatedObject *associatedObject, *association;
}

- (void)setUp {
    [super setUp];

    object = [NSObject new];
    associatedObject = [SampleAssociatedObject new];
}

- (void)tearDown {
    objc_removeAssociatedObjects(object);
    object = nil;
    associatedObject = nil;
    association = nil;

    [super tearDown];
}

- (void)testDefaultObjectAssociation {
    [object associateKey:ObjectAssociationTestsSampleKey withObject:associatedObject];
    association = [object associationForKey:ObjectAssociationTestsSampleKey];
    XCTAssertEqualObjects(association, associatedObject, @"The association should be made between the two objects");
}

- (void)testAssignObjectAssociation {
    [object associateKey:ObjectAssociationTestsSampleKey withObject:associatedObject policy:OBJC_ASSOCIATION_ASSIGN];
    association = [object associationForKey:ObjectAssociationTestsSampleKey];
    XCTAssertEqualObjects(association, associatedObject, @"The association should be made between the two objects");
}

- (void)testAtomicRetainObjectAssociation {
    [object associateKey:ObjectAssociationTestsSampleKey withObject:associatedObject policy:OBJC_ASSOCIATION_RETAIN];
    association = [object associationForKey:ObjectAssociationTestsSampleKey];
    XCTAssertEqualObjects(association, associatedObject, @"The association should be made between the two objects");
}

- (void)testNonatomicRetainObjectAssociation {
    [object associateKey:ObjectAssociationTestsSampleKey withObject:associatedObject policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    association = [object associationForKey:ObjectAssociationTestsSampleKey];
    XCTAssertEqualObjects(association, associatedObject, @"The association should be made between the two objects");
}

- (void)testAtomicCopyObjectAssociation {
    [object associateKey:ObjectAssociationTestsSampleKey withObject:associatedObject policy:OBJC_ASSOCIATION_COPY];
    association = [object associationForKey:ObjectAssociationTestsSampleKey];
    XCTAssertNotEqualObjects(association, associatedObject, @"The association should be made between the first object and a copy of the second");
    XCTAssertEqualObjects(association.name, associatedObject.name, @"The object should be a true copy of the original");
}

- (void)testNonatomicCopyObjectAssociation {
    [object associateKey:ObjectAssociationTestsSampleKey withObject:associatedObject policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
    association = [object associationForKey:ObjectAssociationTestsSampleKey];
    XCTAssertNotEqualObjects(association, associatedObject, @"The association should be made between the first object and a copy of the second");
    XCTAssertEqualObjects(association.name, associatedObject.name, @"The object should be a true copy of the original");
}

- (void)testClearingInvalidAssociation {
    XCTAssertNoThrow([object associationForKey:ObjectAssociationTestsSampleKey], @"The clear method should not fail on an invalid association");
}

- (void)testClearingSingleAssociation {
    [object associateKey:ObjectAssociationTestsSampleKey withObject:associatedObject policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    NSObject *extraObject = [NSObject new];
    [object associateKey:ObjectAssociationTestsExtraKey withObject:extraObject policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];

    [object clearAssociationForKey:ObjectAssociationTestsSampleKey];
    XCTAssertNil([object associationForKey:ObjectAssociationTestsSampleKey], @"The association with the specified key should be cleared");
    XCTAssertNotNil([object associationForKey:ObjectAssociationTestsExtraKey], @"Only the indicated association should be cleared");
}

- (void)testClearingAllAssociations {
    [object associateKey:ObjectAssociationTestsSampleKey withObject:associatedObject policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    NSObject *extraObject = [NSObject new];
    [object associateKey:ObjectAssociationTestsExtraKey withObject:extraObject policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];

    [object clearAllAssociations];
    XCTAssertNil([object associationForKey:ObjectAssociationTestsSampleKey], @"All object associations for the specified object should be cleared");
    XCTAssertNil([object associationForKey:ObjectAssociationTestsExtraKey], @"All object associations for the specified object should be cleared");
}

@end

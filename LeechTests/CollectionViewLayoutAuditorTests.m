//
//  CollectionViewLayoutAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 5/11/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+
#import "TestCollectionViewLayout.h"

//  Production
#import "LTTCollectionViewLayoutAuditor.h"


@interface CollectionViewLayoutAuditorTests : XCTestCase

@end

@implementation CollectionViewLayoutAuditorTests {
    TestCollectionViewLayout *layout;
}

- (void)setUp {
    [super setUp];

    layout = [TestCollectionViewLayout new];
}

- (void)tearDown {
    layout = nil;

    [super tearDown];
}

#pragma mark - Supercalls

- (void)testAuditingOfLayoutAttributesForElementsInRectMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UICollectionViewLayout class], @selector(layoutAttributesForElementsInRect:)));
    [LTTCollectionViewLayoutAuditor auditLayoutAttributesForElementsInRectMethods];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UICollectionViewLayout class], @selector(layoutAttributesForElementsInRect:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    CGRect sampleRect = CGRectMake(1, 2, 3, 4);
    [layout layoutAttributesForElementsInRect:sampleRect];
    XCTAssertTrue([LTTCollectionViewLayoutAuditor didCallSuperLayoutAttributesForElementsInRect], @"The layout subclass should call its superclass' implementation");
    CGRect auditedRect = [LTTCollectionViewLayoutAuditor rectForLayoutAttributes];
    XCTAssertTrue(CGRectEqualToRect(auditedRect, sampleRect), @"The rect for attributes should be passed to the superclass");
    [LTTCollectionViewLayoutAuditor stopAuditingLayoutAttributesForElementsInRectMethods];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UICollectionViewLayout class], @selector(layoutAttributesForElementsInRect:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfLayoutAttributesForItemAtIndexPathMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UICollectionViewLayout class], @selector(layoutAttributesForItemAtIndexPath:)));
    [LTTCollectionViewLayoutAuditor auditLayoutAttributesForItemAtIndexPathMethods];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UICollectionViewLayout class], @selector(layoutAttributesForItemAtIndexPath:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSIndexPath *samplePath = [NSIndexPath indexPathForItem:1 inSection:2];
    [layout layoutAttributesForItemAtIndexPath:samplePath];
    XCTAssertTrue([LTTCollectionViewLayoutAuditor didCallSuperLayoutAttributesForItemAtIndexPath], @"The layout subclass should call its superclass' implementation");
    NSIndexPath *auditedPath = [LTTCollectionViewLayoutAuditor indexPathForLayoutAttributes];
    XCTAssertEqualObjects(auditedPath, samplePath, @"The index path for attributes should be passed to the superclass");
    [LTTCollectionViewLayoutAuditor stopAuditingLayoutAttributesForItemAtIndexPathMethods];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UICollectionViewLayout class], @selector(layoutAttributesForItemAtIndexPath:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end

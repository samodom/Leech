//
//  LayoutConstraintTests.m
//  Leech
//
//  Created by Sam Odom on 3/6/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTLayoutConstraintChecker.h"

@interface LayoutConstraintTests : XCTestCase

@end

@implementation LayoutConstraintTests {
    UIView *viewOne, *viewTwo;
    NSLayoutConstraint *constraint, *otherConstraint;
}

- (void)setUp {
    [super setUp];

    viewOne = [UIView new];
    viewTwo = [UIView new];
    constraint = [NSLayoutConstraint constraintWithItem:viewOne
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:viewTwo
                                              attribute:NSLayoutAttributeTop
                                             multiplier:2.0
                                               constant:3.0];
}

- (void)tearDown {
    viewOne = nil;
    viewTwo = nil;
    constraint = nil;
    otherConstraint = nil;

    [super tearDown];
}

#pragma mark - Constraint retrieval

- (void)testLayoutConstraintsRetrievedByAttribute {
    otherConstraint = [NSLayoutConstraint constraintWithItem:viewOne
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:viewTwo
                                                   attribute:NSLayoutAttributeBaseline
                                                  multiplier:1.0
                                                    constant:0.0];
    NSArray *constraintArray = [LTTLayoutConstraintChecker constraintsForItem:viewOne attribute:NSLayoutAttributeCenterX constraints:@[constraint, otherConstraint]];
    XCTAssertEqual(constraintArray.count, (NSUInteger)1, @"Only one constraint should be returned");
    otherConstraint = [NSLayoutConstraint constraintWithItem:constraint.secondItem
                                                   attribute:constraint.secondAttribute
                                                   relatedBy:constraint.relation
                                                      toItem:constraint.firstItem
                                                   attribute:constraint.firstAttribute
                                                  multiplier:constraint.multiplier
                                                    constant:constraint.constant];
    constraintArray = [LTTLayoutConstraintChecker constraintsForItem:viewOne attribute:NSLayoutAttributeCenterX constraints:@[constraint, otherConstraint]];
    XCTAssertEqual(constraintArray.count, (NSUInteger)2, @"Both constraints should be returned");
}

#pragma mark - Equivalence

- (void)testLayoutConstraintsAreEquivalent {
    otherConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem
                                                   attribute:constraint.firstAttribute
                                                   relatedBy:constraint.relation
                                                      toItem:constraint.secondItem
                                                   attribute:constraint.secondAttribute
                                                  multiplier:constraint.multiplier
                                                    constant:constraint.constant];
    XCTAssertTrue([LTTLayoutConstraintChecker constraint:constraint equalToConstraint:otherConstraint], @"The two constraints should be considered equivalent");
}

- (void)testConstraintsUnequalWithMismatchedFirstItems {
    otherConstraint = [NSLayoutConstraint constraintWithItem:[UIView new]
                                                   attribute:constraint.firstAttribute
                                                   relatedBy:constraint.relation
                                                      toItem:constraint.secondItem
                                                   attribute:constraint.secondAttribute
                                                  multiplier:constraint.multiplier
                                                    constant:constraint.constant];
    XCTAssertFalse([LTTLayoutConstraintChecker constraint:constraint equalToConstraint:otherConstraint], @"The two constraints should not be considered equivalent");
}

- (void)testConstraintsUnequalWithMismatchedFirstAttributes {
    otherConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:constraint.relation
                                                      toItem:constraint.secondItem
                                                   attribute:constraint.secondAttribute
                                                  multiplier:constraint.multiplier
                                                    constant:constraint.constant];
    XCTAssertFalse([LTTLayoutConstraintChecker constraint:constraint equalToConstraint:otherConstraint], @"The two constraints should not be considered equivalent");
}

- (void)testConstraintsUnequalWithMismatchedRelations {
    otherConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem
                                                   attribute:constraint.firstAttribute
                                                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                      toItem:constraint.secondItem
                                                   attribute:constraint.secondAttribute
                                                  multiplier:constraint.multiplier
                                                    constant:constraint.constant];
    XCTAssertFalse([LTTLayoutConstraintChecker constraint:constraint equalToConstraint:otherConstraint], @"The two constraints should not be considered equivalent");
}

- (void)testConstraintsUnequalWithMismatchedSecondItems {
    otherConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem
                                                   attribute:constraint.firstAttribute
                                                   relatedBy:constraint.relation
                                                      toItem:[UIView new]
                                                   attribute:constraint.secondAttribute
                                                  multiplier:constraint.multiplier
                                                    constant:constraint.constant];
    XCTAssertFalse([LTTLayoutConstraintChecker constraint:constraint equalToConstraint:otherConstraint], @"The two constraints should not be considered equivalent");
}

- (void)testConstraintsUnequalWithMismatchedSecondAttributes {
    otherConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem
                                                   attribute:constraint.firstAttribute
                                                   relatedBy:constraint.relation
                                                      toItem:constraint.secondItem
                                                   attribute:NSLayoutAttributeLeading
                                                  multiplier:constraint.multiplier
                                                    constant:constraint.constant];
    XCTAssertFalse([LTTLayoutConstraintChecker constraint:constraint equalToConstraint:otherConstraint], @"The two constraints should not be considered equivalent");
}

- (void)testConstraintsUnequalWithMismatchedMultipliers {
    otherConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem
                                                   attribute:constraint.firstAttribute
                                                   relatedBy:constraint.relation
                                                      toItem:constraint.secondItem
                                                   attribute:constraint.secondAttribute
                                                  multiplier:15.0
                                                    constant:constraint.constant];
    XCTAssertFalse([LTTLayoutConstraintChecker constraint:constraint equalToConstraint:otherConstraint], @"The two constraints should not be considered equivalent");
}

- (void)testConstraintsUnequalWithMismatchedConstants {
    otherConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem
                                                   attribute:constraint.firstAttribute
                                                   relatedBy:constraint.relation
                                                      toItem:constraint.secondItem
                                                   attribute:constraint.secondAttribute
                                                  multiplier:constraint.multiplier
                                                    constant:100.0];
    XCTAssertFalse([LTTLayoutConstraintChecker constraint:constraint equalToConstraint:otherConstraint], @"The two constraints should not be considered equivalent");
}

@end

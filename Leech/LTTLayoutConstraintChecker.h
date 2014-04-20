//
//  LTTLayoutConstraintChecker.h
//  Leech
//
//  Created by Sam Odom on 3/6/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

/**
 LTTLayoutConstraintChecker provides methods to aid in the testing of Auto Layout view constraints
 */
@interface LTTLayoutConstraintChecker : NSObject

/** @name Filtering constraints */

/**
 Filters an array of NSLayoutConstraint objects based on a layout item and attribute pair
 
 @return NSArray of constraints matching both the item and constraint as either the first or second item in the constraint
 @param item Object to match
 @param attribute Layout attribute to match
 @param constraints NSArray of NSLayoutConstraint objects matching the item-attribute pair
 */
+ (NSArray*)constraintsForItem:(id)item attribute:(NSLayoutAttribute)attribute constraints:(NSArray*)constraints;


/** @name Testing for equality */

/**
 Equality test for two NSLayoutConstraint objects that matches based on items, attributes, relation, multiplier and constant.
 
 @return BOOL value indicating whether the two constraints are equivalent
 
 @param constraintOne One of the constraints to test for equality
 @param constraintTwo The other constraint to test for equality
 
 @warning This test does not account for equivalent constraints with transposed items
 @warning This test does not account for differences in priority
 */
+ (BOOL)constraint:(NSLayoutConstraint*)constraintOne equalToConstraint:(NSLayoutConstraint*)constraintTwo;

@end

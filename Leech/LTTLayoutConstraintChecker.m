//
//  LTTLayoutConstraintChecker.m
//  Leech
//
//  Created by Sam Odom on 3/6/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTLayoutConstraintChecker.h"

@implementation LTTLayoutConstraintChecker

#pragma mark - Constraint retrieval

+ (NSArray *)constraintsForItem:(id)item attribute:(NSLayoutAttribute)attribute constraints:(NSArray *)constraints {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSLayoutConstraint *constraint = (NSLayoutConstraint*) evaluatedObject;
        if (constraint.firstItem == item && constraint.firstAttribute == attribute)
            return YES;
        if (constraint.secondItem == item && constraint.secondAttribute == attribute)
            return YES;

        return NO;
    }];

    return [constraints filteredArrayUsingPredicate:predicate];
}

#pragma mark - Equivalence

+ (BOOL)constraint:(NSLayoutConstraint *)constraintOne equalToConstraint:(NSLayoutConstraint *)constraintTwo {
    if (constraintOne.firstItem != constraintTwo.firstItem)
        return NO;
    if (constraintOne.secondItem != constraintTwo.secondItem)
        return NO;
    if (constraintOne.firstAttribute != constraintTwo.firstAttribute)
        return NO;
    if (constraintOne.secondAttribute != constraintTwo.secondAttribute)
        return NO;
    if (constraintOne.relation != constraintTwo.relation)
        return NO;
    if (constraintOne.multiplier != constraintTwo.multiplier)
        return NO;
    if (constraintOne.constant != constraintTwo.constant)
        return NO;

    return YES;
}

@end

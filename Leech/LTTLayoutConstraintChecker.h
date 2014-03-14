//
//  LTTLayoutConstraintChecker.h
//  Leech
//
//  Created by Sam Odom on 3/6/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

@interface LTTLayoutConstraintChecker : NSObject

+ (NSArray*)constraintsForItem:(id)item attribute:(NSLayoutAttribute)attribute constraints:(NSArray*)constraints;

+ (BOOL)constraint:(NSLayoutConstraint*)constraintOne equalToConstraint:(NSLayoutConstraint*)constraintTwo;

@end

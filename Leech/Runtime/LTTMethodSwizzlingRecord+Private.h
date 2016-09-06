//
//  LTTMethodSwizzlingRecord.h
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import "LTTMethodSwizzlingRecord.h"

@interface LTTMethodSwizzlingRecord ()

@property NSString *className;
@property SEL realSelector;
@property SEL fakeSelector;

@end

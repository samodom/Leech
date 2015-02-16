//
//  SampleAssociatedObject.m
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import "SampleAssociatedObject.h"

@implementation SampleAssociatedObject

- (id)copyWithZone:(NSZone *)zone {
    SampleAssociatedObject *copyOfSelf = [SampleAssociatedObject new];
    copyOfSelf.name = [self.name copy];
    return copyOfSelf;
}

@end

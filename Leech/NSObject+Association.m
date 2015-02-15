//
//  NSObject+Association.m
//  PWTesting
//
//  Created by Sam Odom on 9/2/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+Association.h"

@implementation NSObject (Association)

- (void)associateKey:(const void *)key withValue:(id)value {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (id)associationForKey:(const void *)key {
    return objc_getAssociatedObject(self, key);
}

- (id)dissociateKey:(const void *)key {
    id association = [self associationForKey:key];
    [self clearKey:key];
    return association;
}

- (void)clearKey:(const void *)key {
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_ASSIGN);
}

@end

//
//  NSObject+ObjectAssociation.m
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import "NSObject+ObjectAssociation.h"

@implementation NSObject (ObjectAssociation)

- (void)associateKey:(nonnull const char *)key withObject:(nonnull id)object {
    [self associateKey:key withObject:object policy:OBJC_ASSOCIATION_ASSIGN];
}

- (void)associateKey:(nonnull const char *)key withObject:(nonnull id)object policy:(objc_AssociationPolicy)policy {
    objc_setAssociatedObject(self, key, object, policy);
}

- (nullable id)associationForKey:(nonnull const char *)key {
    id object = objc_getAssociatedObject(self, key);
    return object;
}

- (void)clearAssociationForKey:(nonnull const char *)key {
    objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_ASSIGN);
}

- (void)clearAllAssociations {
    objc_removeAssociatedObjects(self);
}

@end

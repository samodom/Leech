//
//  NSManagedObjectContext+Leech.m
//  Leech
//
//  Created by Sam Odom on 3/4/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <objc/runtime.h>

#import "NSManagedObjectContext+Leech.h"

#import "LTTMethodSwizzler.h"

const char *ManagedObjectContextBlockToPerformKey = "ManagedObjectContextBlockToPerformKey";

@implementation NSManagedObjectContext (Leech)

#pragma mark - Perform block methods

+ (core_data_perform_t)blockToPerform {
    return objc_getAssociatedObject([NSManagedObjectContext class], ManagedObjectContextBlockToPerformKey);
}

#pragma mark -performBlock:

+ (void)auditPerformBlock {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlock:) selectorTwo:@selector(Leech_PerformBlock:)];
}

- (void)Leech_PerformBlock:(core_data_perform_t)block {
    objc_setAssociatedObject([NSManagedObjectContext class], ManagedObjectContextBlockToPerformKey, block, OBJC_ASSOCIATION_RETAIN);
}

+ (void)stopAuditingPerformBlock {
    objc_setAssociatedObject([NSManagedObjectContext class], ManagedObjectContextBlockToPerformKey, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlock:) selectorTwo:@selector(Leech_PerformBlock:)];
}

#pragma mark -performBlockAndWait:

+ (void)auditPerformBlockAndWait {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlockAndWait:) selectorTwo:@selector(Leech_PerformBlockAndWait:)];
}

- (void)Leech_PerformBlockAndWait:(core_data_perform_t)block {
    objc_setAssociatedObject([NSManagedObjectContext class], ManagedObjectContextBlockToPerformKey, block, OBJC_ASSOCIATION_RETAIN);
}

+ (void)stopAuditingPerformBlockAndWait {
    objc_setAssociatedObject([NSManagedObjectContext class], ManagedObjectContextBlockToPerformKey, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlockAndWait:) selectorTwo:@selector(Leech_PerformBlockAndWait:)];
}

@end

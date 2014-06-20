//
//  LTTCoreDataAuditor.m
//  Leech
//
//  Created by Sam Odom on 3/4/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTCoreDataAuditor.h"

#import "LTTMethodSwizzler.h"

////////////////////////////////////////////////////////////////////////////////
//  Category on NSManagedObjectContext
////////////////////////////////////////////////////////////////////////////////

const char *CDABlockToPerformKey = "CDABlockToPerform";
const char *CDABlocksToPerformKey = "CDABlocksToPerform";
const char *CDAAuditingMultipleBlocksKey = "CDAAuditingMultipleBlocks";

@implementation NSManagedObjectContext (Leech)

- (void)Leech_PerformBlock:(core_data_perform_t)block {
    NSNumber *multipleAuditFlag = objc_getAssociatedObject([NSManagedObjectContext class], CDAAuditingMultipleBlocksKey);
    if (multipleAuditFlag.boolValue) {
        NSMutableArray *blocks = [(NSArray*)objc_getAssociatedObject([NSManagedObjectContext class], CDABlocksToPerformKey) mutableCopy];
        if (!blocks) {
            blocks = [NSMutableArray new];
        }
        [blocks addObject:block];
        objc_setAssociatedObject([NSManagedObjectContext class], CDABlocksToPerformKey, [NSArray arrayWithArray:blocks], OBJC_ASSOCIATION_RETAIN);
    }
    else {
        objc_setAssociatedObject([NSManagedObjectContext class], CDABlockToPerformKey, block, OBJC_ASSOCIATION_RETAIN);
    }
}

//- (void)Leech_PerformBlockAndWait:(core_data_perform_t)block {
//    NSNumber *multipleAuditFlag = objc_getAssociatedObject([NSManagedObjectContext class], CDAAuditingMultipleBlocksKey);
//    if (multipleAuditFlag.boolValue) {
//        NSMutableArray *blocks = [(NSArray*)objc_getAssociatedObject([NSManagedObjectContext class], CDABlocksToPerformKey) mutableCopy];
//        if (!blocks) {
//            blocks = [NSMutableArray new];
//        }
//        [blocks addObject:block];
//        objc_setAssociatedObject([NSManagedObjectContext class], CDABlocksToPerformKey, [NSArray arrayWithArray:blocks], OBJC_ASSOCIATION_RETAIN);
//    }
//    else {
//        objc_setAssociatedObject([NSManagedObjectContext class], CDABlockToPerformKey, block, OBJC_ASSOCIATION_RETAIN);
//    }
//}

@end


////////////////////////////////////////////////////////////////////////////////
//  Category on NSManagedObject
////////////////////////////////////////////////////////////////////////////////

const char *CDADidCallWillAccessValueForKey = "CDADidCallWillAccessValueForKey";
const char *CDAKeyForWillAccessValueForKey = "CDAKeyForWillAccessValueForKey";

const char *CDADidCallDidAccessValueForKey = "CDADidCallDidAccessValueForKey";
const char *CDAKeyForDidAccessValueForKey = "CDAKeyForDidAccessValueForKey";

const char *CDADidCallWillChangeValueForKey = "CDADidCallWillChangeValueForKey";
const char *CDAKeyForWillChangeValueForKey = "CDAKeyForWillChangeValueForKey";

const char *CDADidCallDidChangeValueForKey = "CDADidCallDidChangeValueForKey";
const char *CDAKeyForDidChangeValueForKey = "CDAKeyForDidChangeValueForKey";


@implementation NSManagedObject (Leech)

- (void)Leech_WillAccessValueForKey:(NSString *)key {
    NSLog(@"In will access swizzled");
    objc_setAssociatedObject(self, CDADidCallWillAccessValueForKey, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, CDAKeyForWillAccessValueForKey, key, OBJC_ASSOCIATION_RETAIN);
}

- (void)Leech_DidAccessValueForKey:(NSString *)key {
    
}

- (void)Leech_WillChangeValueForKey:(NSString *)key {
    
}

- (void)Leech_DidChangeValueForKey:(NSString *)key {
    
}

@end


////////////////////////////////////////////////////////////////////////////////
//  Implementation of Core Data auditor
////////////////////////////////////////////////////////////////////////////////

@implementation LTTCoreDataAuditor

#pragma mark - Perform block methods

+ (core_data_perform_t)blockToPerform {
    return objc_getAssociatedObject([NSManagedObjectContext class], CDABlockToPerformKey);
}

+ (NSArray *)blocksToPerform {
    return objc_getAssociatedObject([NSManagedObjectContext class], CDABlocksToPerformKey);
}

#pragma mark -performBlock:

+ (void)auditPerformBlock {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlock:) selectorTwo:@selector(Leech_PerformBlock:)];
}

+ (void)stopAuditingPerformBlock {
    objc_setAssociatedObject([NSManagedObjectContext class], CDABlockToPerformKey, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlock:) selectorTwo:@selector(Leech_PerformBlock:)];
}

+ (void)auditPerformMultipleBlocks {
    objc_setAssociatedObject([NSManagedObjectContext class], CDAAuditingMultipleBlocksKey, @(YES), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlock:) selectorTwo:@selector(Leech_PerformBlock:)];
}

+ (void)stopAuditingPerformMultipleBlocks {
    objc_setAssociatedObject([NSManagedObjectContext class], CDAAuditingMultipleBlocksKey, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([NSManagedObjectContext class], CDABlocksToPerformKey, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlock:) selectorTwo:@selector(Leech_PerformBlock:)];
}

#pragma mark -performBlockAndWait:

+ (void)auditPerformBlockAndWait {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlockAndWait:) selectorTwo:@selector(Leech_PerformBlock:)];
}

+ (void)stopAuditingPerformBlockAndWait {
    objc_setAssociatedObject([NSManagedObjectContext class], CDABlockToPerformKey, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlockAndWait:) selectorTwo:@selector(Leech_PerformBlock:)];
}

+ (void)auditPerformMultipleBlocksAndWait {
    objc_setAssociatedObject([NSManagedObjectContext class], CDAAuditingMultipleBlocksKey, @(YES), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlockAndWait:) selectorTwo:@selector(Leech_PerformBlock:)];
}

+ (void)stopAuditingPerformMultipleBlocksAndWait {
    objc_setAssociatedObject([NSManagedObjectContext class], CDAAuditingMultipleBlocksKey, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([NSManagedObjectContext class], CDABlocksToPerformKey, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObjectContext class] selectorOne:@selector(performBlockAndWait:) selectorTwo:@selector(Leech_PerformBlock:)];
}


#pragma mark - Managed object access/mutation

#pragma mark Attribute access

+ (void)auditAccessNotificationsForManagedObject:(NSManagedObject *)managedObject onAttribute:(NSString *)attributeName {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[managedObject class] selectorOne:@selector(willAccessValueForKey:) selectorTwo:@selector(Leech_WillAccessValueForKey:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[managedObject class] selectorOne:@selector(didAccessValueForKey:) selectorTwo:@selector(Leech_DidAccessValueForKey:)];
}

+ (void)stopAuditingAccessNotificationsForManagedObject:(NSManagedObject *)managedObject {
    objc_setAssociatedObject(self, CDADidCallWillAccessValueForKey, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, CDAKeyForWillAccessValueForKey, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObject class] selectorOne:@selector(willAccessValueForKey:) selectorTwo:@selector(Leech_WillAccessValueForKey:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObject class] selectorOne:@selector(didAccessValueForKey:) selectorTwo:@selector(Leech_DidAccessValueForKey:)];
}

+ (BOOL)didCallWillAccessValueForKeyOnObject:(NSManagedObject *)object {
    NSNumber *didCall = objc_getAssociatedObject(object, CDADidCallWillAccessValueForKey);
    return didCall.boolValue;
}

+ (BOOL)didCallDidAccessValueForKeyOnObject:(NSManagedObject *)object {
    return NO;
}

+ (NSString *)keyForWillAccessValueOnObject:(NSManagedObject *)object {
    return nil;
}

+ (NSString *)keyForDidAccessValueOnObject:(NSManagedObject *)object {
    return nil;
}

#pragma mark Attribute mutation

+ (void)auditChangeNotificationsForManagedObject:(NSManagedObject *)managedObject onAttribute:(NSString *)attributeName {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObject class] selectorOne:@selector(willChangeValueForKey:) selectorTwo:@selector(Leech_WillChangeValueForKey:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObject class] selectorOne:@selector(didChangeValueForKey:) selectorTwo:@selector(Leech_DidChangeValueForKey:)];
}

+ (void)stopAuditingChangeNotificationsForManagedObject:(NSManagedObject *)mangedObject {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObject class] selectorOne:@selector(willChangeValueForKey:) selectorTwo:@selector(Leech_WillChangeValueForKey:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[NSManagedObject class] selectorOne:@selector(didChangeValueForKey:) selectorTwo:@selector(Leech_DidChangeValueForKey:)];
}

+ (BOOL)didCallWillChangeValueForKeyOnObject:(NSManagedObject *)object {
    return NO;
}

+ (BOOL)didCallDidChangeValueForKeyOnObject:(NSManagedObject *)object {
    return NO;
}

+ (NSString *)keyForWillChangeValueOnObject:(NSManagedObject *)object {
    return nil;
}

+ (NSString *)keyForDidChangeValueOnObject:(NSManagedObject *)object {
    return nil;
}

@end

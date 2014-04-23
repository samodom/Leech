//
//  LTTMockNotificationCenter.m
//  CanWeNetwork
//
//  Created by Sam Odom on 8/16/13.
//  Copyright (c) 2013 CanWe Studios, LLC. All rights reserved.
//

#import "LTTMockNotificationCenter.h"

#import "LTTMethodSwizzler.h"

const char *ReplacementDefaultCenter = "ReplacementDefaultCenter";

////////////////////////////////////////////////////////////////////////////////
//  Category on NSNotificationCenter
////////////////////////////////////////////////////////////////////////////////

@implementation NSNotificationCenter (Leech)

+ (instancetype)Leech_DefaultCenter {
    return objc_getAssociatedObject([NSNotificationCenter class], ReplacementDefaultCenter);
}

@end

////////////////////////////////////////////////////////////////////////////////
//  Mock Notification Center implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTMockNotificationCenter {
    NSMutableSet *dispatchTable;
    NSMutableSet *receivedNotifications;
}

#pragma mark - Default Center replacement

+ (void)replaceDefaultCenter:(LTTMockNotificationCenter *)mockCenter {
    [LTTMethodSwizzler swapClassMethodsForClass:[NSNotificationCenter class] selectorOne:@selector(defaultCenter) selectorTwo:@selector(Leech_DefaultCenter)];
    objc_setAssociatedObject([NSNotificationCenter class], ReplacementDefaultCenter, mockCenter, OBJC_ASSOCIATION_RETAIN);
}

+ (void)restoreDefaultCenter {
    objc_setAssociatedObject([NSNotificationCenter class], ReplacementDefaultCenter, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapClassMethodsForClass:[NSNotificationCenter class] selectorOne:@selector(defaultCenter) selectorTwo:@selector(Leech_DefaultCenter)];
}

#pragma mark - Dispatch Entry

- (LTTFakeNotificationDispatchEntry *)dispatchEntryForObserver:(id)observer name:(NSString *)notificationName object:(id)publisher {
    for (LTTFakeNotificationDispatchEntry *entry in dispatchTable) {
        if ([notificationName isEqualToString:entry.notificationName] &&
            [observer isEqual:entry.observer] &&
            (publisher == nil || [publisher isEqual:entry.publisher]))
            return entry;
    }

    return nil;
}

#pragma mark - Add Observer

- (void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(id)notificationSender {
    NSParameterAssert(notificationObserver != nil);
    NSParameterAssert(notificationName.length > 0);
    LTTFakeNotificationDispatchEntry *entry = [LTTFakeNotificationDispatchEntry entryForNotification:notificationName observer:notificationObserver object:notificationSender selector:notificationSelector];
    [dispatchTable addObject:entry];
}

- (id)addObserverForName:(NSString *)notificationName object:(id)notificationSender queue:(NSOperationQueue *)queue usingBlock:(handler_block_t)handler {
    LTTFakeNotificationDispatchEntry *entry = [LTTFakeNotificationDispatchEntry entryForNotification:notificationName queue:queue object:notificationSender handler:handler];
    [dispatchTable addObject:entry];
    return entry;
}

#pragma mark - Remove Observer

- (void)removeObserver:(id)notificationObserver {
    if (!notificationObserver)
        return;
    for (LTTFakeNotificationDispatchEntry *entry in [dispatchTable copy]) {
        if ([entry.observer isEqual:notificationObserver])
            [dispatchTable removeObject:entry];
    }
}

- (void)removeObserver:(id)notificationObserver name:(NSString *)notificationName object:(id)notificationSender {
    if (!notificationObserver)
        return;

    for (LTTFakeNotificationDispatchEntry *entry in [dispatchTable copy]) {
        BOOL sendersEqual = (notificationSender == nil) || [entry.publisher isEqual:notificationSender];
        BOOL notificationNameMatch = notificationName == nil || [entry.notificationName isEqualToString:notificationName];
        if ([entry.observer isEqual:notificationObserver] && notificationNameMatch && sendersEqual)
            [dispatchTable removeObject:entry];
    }
}


#pragma mark - Has Observer

- (BOOL)hasObserver:(id)observer {
    for (LTTFakeNotificationDispatchEntry *entry in dispatchTable) {
        if ([entry.observer isEqual:observer])
            return YES;
    }
    return NO;
}

- (BOOL)hasObserver:(id)observer forNotificationName:(NSString *)notificationName {
    for (LTTFakeNotificationDispatchEntry *entry in dispatchTable) {
        if ([entry.observer isEqual:observer] && [entry.notificationName isEqualToString:notificationName])
            return YES;
    }
    return NO;
}

- (BOOL)hasObserver:(id)observer forNotificationName:(NSString *)notificationName object:(id)object {
    for (LTTFakeNotificationDispatchEntry *entry in dispatchTable) {
        if ([entry.observer isEqual:observer] && [entry.notificationName isEqualToString:notificationName] && [entry.publisher isEqual:object])
            return YES;
    }
    return NO;
}

#pragma mark - Notifications

- (void)postNotification:(NSNotification *)notification {
    [receivedNotifications addObject:notification];
}

- (void)postNotificationName:(NSString *)name object:(id)object {
    [receivedNotifications addObject:[NSNotification notificationWithName:name object:object]];
}

- (void)postNotificationName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    [receivedNotifications addObject:[NSNotification notificationWithName:name object:object userInfo:userInfo]];
}

- (BOOL)didReceiveNotification:(NSString *)notificationName fromObject:(id)object {
    for (NSNotification *notification in receivedNotifications) {
        if ([notification.name isEqualToString:notificationName] && [notification.object isEqual:object])
            return YES;
    }
    
    return NO;
}

- (NSNotification *)notification:(NSString *)name fromObject:(id)object {
    for (NSNotification *notification in receivedNotifications) {
        if ([notification.name isEqualToString:name] && [notification.object isEqual:object])
            return notification;
    }
    
    return nil;
}


#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        dispatchTable = [NSMutableSet set];
        receivedNotifications = [NSMutableSet set];
    }
    return self;
}

@end

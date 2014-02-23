//
//  LTTFakeNotificationDispatchEntry.m
//  CanWeNetwork
//
//  Created by Sam Odom on 9/26/13.
//  Copyright (c) 2013 CanWe Studios, LLC. All rights reserved.
//

#import "LTTFakeNotificationDispatchEntry.h"

@implementation LTTFakeNotificationDispatchEntry

+ (LTTFakeNotificationDispatchEntry *)entryForNotification:(NSString *)name observer:(id)observer object:(id)object selector:(SEL)selector {
    LTTFakeNotificationDispatchEntry *entry = [self new];
    entry.notificationName = name;
    entry.observer = observer;
    entry.publisher = object;
    entry.selector = selector;
    return entry;
}

+ (LTTFakeNotificationDispatchEntry *)entryForNotification:(NSString *)name queue:(NSOperationQueue *)queue object:(id)object handler:(handler_block_t)handler {
    LTTFakeNotificationDispatchEntry *entry = [self new];
    entry.notificationName = name;
    entry.observer = entry;
    entry.publisher = object;
    entry.queue = queue;
    entry.handlerBlock = handler;
    return entry;
}

@end

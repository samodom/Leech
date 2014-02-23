//
//  LTTMockNotificationCenter.h
//  CanWeNetwork
//
//  Created by Sam Odom on 8/16/13.
//  Copyright (c) 2013 CanWe Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LTTFakeNotificationDispatchEntry.h"

@interface LTTMockNotificationCenter : NSObject

- (void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(id)notificationSender;
- (id)addObserverForName:(NSString *)notificationName object:(id)notificationSender queue:(NSOperationQueue *)queue usingBlock:(handler_block_t)handlerBlock;

- (void)removeObserver:(id)notificationObserver;
- (void)removeObserver:(id)notificationObserver name:(NSString *)notificationName object:(id)notificationSender;

- (void)postNotification:(NSNotification *)notification;
- (void)postNotificationName:(NSString*)name object:(id)anObject;
- (void)postNotificationName:(NSString*)name object:(id)anObject userInfo:(NSDictionary *)userInfo;

- (BOOL)hasObserver:(id)observer;
- (BOOL)hasObserver:(id)observer forNotificationName:(NSString*)notificationName;
- (BOOL)hasObserver:(id)observer forNotificationName:(NSString*)notificationName object:(id)object;
- (BOOL)didReceiveNotification:(NSString*)notificationName fromObject:(id)object;

- (NSNotification*)notification:(NSString*)name fromObject:(id)object;

- (LTTFakeNotificationDispatchEntry*)dispatchEntryForObserver:(id)observer name:(NSString*)notificationName object:(id)publisher;

@end

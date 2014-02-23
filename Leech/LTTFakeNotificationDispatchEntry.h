//
//  LTTFakeNotificationDispatchEntry.h
//  CanWeNetwork
//
//  Created by Sam Odom on 9/26/13.
//  Copyright (c) 2013 CanWe Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^handler_block_t)(NSNotification*);

@interface LTTFakeNotificationDispatchEntry : NSObject

@property (strong) NSString *notificationName;
@property (strong) id observer;
@property (strong) id publisher;
@property SEL selector;
@property (strong) handler_block_t handlerBlock;
@property (weak) NSOperationQueue *queue;

+ (LTTFakeNotificationDispatchEntry*)entryForNotification:(NSString*)name observer:(id)observer object:(id)object selector:(SEL)selector;

+ (LTTFakeNotificationDispatchEntry*)entryForNotification:(NSString *)name queue:(NSOperationQueue*)queue object:(id)object handler:(handler_block_t)handler;

@end

//
//  LTTObjectAuditor.h
//  Leech
//
//  Created by Sam Odom on 4/1/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTObjectAuditor : NSObject

+ (void)auditPerformSelectorOrMainThreadMethod:(NSObject*)object;
+ (void)stopAuditingPerformSelectorOnMainThreadMethod:(NSObject*)object;
+ (SEL)selectorToPerform:(NSObject*)auditedObject;
+ (id)argumentToSelector:(NSObject*)auditedObjecdt;
+ (BOOL)waitUntilDoneFlag:(NSObject*)auditedObject;

@end

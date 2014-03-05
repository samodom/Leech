//
//  NSManagedObjectContext+Leech.h
//  Leech
//
//  Created by Sam Odom on 3/4/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

typedef void (^core_data_perform_t)(void);

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Leech)

+ (void)auditPerformBlock;
+ (void)stopAuditingPerformBlock;

+ (void)auditPerformBlockAndWait;
+ (void)stopAuditingPerformBlockAndWait;

+ (core_data_perform_t)blockToPerform;

@end

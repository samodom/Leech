//
//  LTTCoreDataAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/4/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 LTTCoreDataAuditor assists in testing code that performs Core Data operations as a synchronous or asynchronous block.
 
 ##Usage
 
 __Step 1__ Begin auditing one of the perform block methods
 
     [LTTCoreDataAuditor auditPerformBlock];
     //  or [LTTCoreDataAuditor auditPerformBlockAndWait];

 __Step 2__ Invoke your method that performs a block of Core Data operations
 
 __Step 3__ Check that a block has been used
 
     core_data_perform_t blockToPerform = [LTTCoreDataAuditor blockToPerform];
     XCTAssertNotNil(blockToPerform,
                     @"The Core Data operations should be performed in a block");
 
 __Step 4__ Check that the expected operations have been performed
 
     blockToPerform();  //  execute the captured block
     //  various assertions to check outcome of Core Data operations
     //  assertion checking that managed object context was saved:
     //  XCTAssertFalse(managedObjectContext.hasChanges, ...);
 
 __Step 5__ End auditing of the perform block methods and clear captured data
 
     [LTTCoreDataAuditor stopAuditingPerformBlock];
     //  or [LTTCoreDataAuditor stopAuditingPerformBlockAndWait];
 
 */

@interface LTTCoreDataAuditor : NSObject

/**
 Block type for Core Data testing
 */
typedef void (^core_data_perform_t)(void);


/** @name Auditing perform block methods */

/**
 Audits performing of Core Data operations in an asynchronous block
 
 @discussion This method replaces the real method implementation of `-[NSManagedObject performBlock:]` with another method that captures the block to perform and does not perform the block
 */
+ (void)auditPerformBlock;

/**
 Ends auditing of asynchronous perform block methods and clears captured data
 */
+ (void)stopAuditingPerformBlock;

/**
 Audits performing of Core Data operations in multiple asynchronous blocks
 
 @discussion This method replaces the real method implementation of `-[NSManagedObject performBlock:]` with another method that captures each block to perform and does not perform the blocks
 */
+ (void)auditPerformMultipleBlocks;

/**
 Ends auditing of multiple asynchronous perform block methods and clears captured data
 */
+ (void)stopAuditingPerformMultipleBlocks;

/**
 Audits performing of Core Data operations in a synchronous block
 
 @discussion This method replaces the real method implementation of `-[NSManagedObject performBlockAndWait:]` with another method that captures the block to perform and does not perform the block
 */
+ (void)auditPerformBlockAndWait;

/**
 Ends auditing of synchronous perform block methods and clears captured data
 */
+ (void)stopAuditingPerformBlockAndWait;

/**
 Audits performing of Core Data operations in multiple synchronous blocks
 
 @discussion This method replaces the real method implementation of `-[NSManagedObject performBlockAndWait:]` with another method that captures each block to perform and does not perform the blocks
 */
+ (void)auditPerformMultipleBlocksAndWait;

/**
 Ends auditing of multiple synchronous perform block methods and clears captured data
 */
+ (void)stopAuditingPerformMultipleBlocksAndWait;


/** @name Accessing audited block to perform */

/**
 @return core_data_perform_t block that has been captured
 */
+ (core_data_perform_t)blockToPerform;

/** @name Accessing multple audited blocks to perform */

/**
 @return NSArray of core_data_perform_t blocks that have been captured
 */
+ (NSArray*)blocksToPerform;


+ (void)auditAccessNotificationsForManagedObject:(NSManagedObject*)managedObject onAttribute:(NSString*)attributeName;
+ (void)stopAuditingAccessNotificationsForManagedObject:(NSManagedObject*)managedObject;
+ (BOOL)didCallWillAccessValueForKeyOnObject:(NSManagedObject*)object;
+ (BOOL)didCallDidAccessValueForKeyOnObject:(NSManagedObject*)object;
+ (NSString*)keyForWillAccessValueOnObject:(NSManagedObject*)object;
+ (NSString*)keyForDidAccessValueOnObject:(NSManagedObject*)object;


+ (void)auditChangeNotificationsForManagedObject:(NSManagedObject*)managedObject onAttribute:(NSString*)attributeName;
+ (void)stopAuditingChangeNotificationsForManagedObject:(NSManagedObject*)mangedObject;
+ (BOOL)didCallWillChangeValueForKeyOnObject:(NSManagedObject*)object;
+ (BOOL)didCallDidChangeValueForKeyOnObject:(NSManagedObject*)object;
+ (NSString*)keyForWillChangeValueOnObject:(NSManagedObject*)object;
+ (NSString*)keyForDidChangeValueOnObject:(NSManagedObject*)object;


@end

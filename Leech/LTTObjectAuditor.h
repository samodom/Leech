//
//  LTTObjectAuditor.h
//  Leech
//
//  Created by Sam Odom on 4/1/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 LTTObjectAuditor aids in the testing of code that performs selectors on the main thread through NSObject methods
 
 ##Usage
 
 __Step 1__ Begin auditing the perform on main thread selector method
 
     [LTTObjectAuditor auditPerformSelectorOnMainThread:<#myObject#>];
 
 __Step 2__ Invoke your code that performs a selector on the main thread
 
     [<#myObject#> performSelectorOnMainThread:@selector(<#selector#>) withObject:<#argument#> waitUntilDone:YES];
 
 __Step 3__ Verify that the object asked itself to perform the selector on the main thread
 
     XCTAssertEqual([LTTObjectAuditor selectorToPerform:<#myObject#>],
                    @selector(<#selector#>),
                    @"The object should perform the selector on the main thread");
     XCTAssertEqualObjects([LTTObjectAuditor argumentToSelector:<#myObject#>],
                            <#argument#>,
                            @"The selector should use the correct argument");
     XCTAssertTrue([LTTObjectAuditor waitUntilDoneFlag:<#myObject#>],
                   @"The object should wait on the selector to finish performing before continuing");
 
 __Step 4__ End auditing of the perform selector method
 
     [LTTObjectAuditor stopAuditingPerformSelectorOnMainThread];
 */
@interface LTTObjectAuditor : NSObject

/**
 Audits performing of selectors on the main thread
 
 @param object NSObject representing the object performing the selector
 */
+ (void)auditPerformSelectorOnMainThread:(NSObject*)object;

/**
 Ends auditing of performing selectors on the main thread and clears captured data
 
 @param object The object being audited
 */
+ (void)stopAuditingPerformSelectorOnMainThread:(NSObject*)object;

/**
 Provides the selector to be performed on the main thread
 
 @return SEL value of the selector to be performed
 
 @param auditedObject The object being audited
 */
+ (SEL)selectorToPerform:(NSObject*)auditedObject;

/**
 Provides the argument passed to the selector to be performed on the main thread
 
 @return id object passed to the selector
 
 @param auditedObject The object being audited
 */
+ (id)argumentToSelector:(NSObject*)auditedObject;

/**
 Indicates whether the selector is to be performed on the main thread synchronously
 
 @return BOOL indicating whether or not the call is synchronous
 
 @param auditedObject The object being audited
 */
+ (BOOL)waitUntilDoneFlag:(NSObject*)auditedObject;

@end

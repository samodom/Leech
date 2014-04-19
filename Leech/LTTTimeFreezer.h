//
//  LTTTimeFreezer.h
//  Leech
//
//  Created by Sam Odom on 3/2/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 LTTTimeFreezer provides a way to *freeze time* during testing so that code attempting to use the current date and time can be given an arbitrary time for the duration of the test.
 
 ##Usage

 __Step 1__ Freeze time
 
    [LTTTimeFreezer freezeTime];

 __Step 2__ (Optional) Set a custom date if needed for manipulation of the current time
 
    [LTTTimeFreezer setFrozenDate:<#otherDate#>];

 __Step 3__ Invoke your method that uses the current time (or some derivation thereof).  For example:
 
    MyClass *myObject = [MyClass myMethodUsingTheCurrentTime];
    XCTAssertEqualObjects(myObject.currentDateProperty,
                          [NSDate date],  //  or <#otherDate#>
                          @"The method should set the current date on the object");
 
 __Step 4__ Unfreeze time
 
    [LTTTimeFreezer unfreezeTime];

 @warning Always unfreeze time at the end of a test where you freeze time or other tests may be affected.
 */

@interface LTTTimeFreezer : NSObject

/** @name Freezing and unfreezing time */

/**
 * Freezes time at the moment of execution so that calls to `+[NSDate date]` will use the frozen time
 *
 * @warning Assertion failure if called when time is already frozen.
 */
+ (void)freezeTime;

/**
 * Unfreezes time so that calls to `+[NSDate date]` will again use the appropriate system time
 *
 * @warning Assertion failure if called when time is not frozen.
 */
+ (void)unfreezeTime;

/** @name Checking if time is frozen */

/**
 * @return BOOL indicating whether or not time has been frozen by LTTTimeFreezer
 */
+ (BOOL)timeIsFrozen;

/** @name Setting frozen date */

/**
 * @param newDate Sets frozen date to be returned by calls to `+[NSDate date]`
 */
+ (void)setFrozenDate:(NSDate*)newDate;

@end

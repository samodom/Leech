//
//  LTTAlertViewAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/31/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 LTTAlertViewAuditor assists in testing code that displays a UIAlertView

 ##Usage
 
 __Step 1__ Begin auditing the initialization and display methods
 
     [LTTAlertViewAuditor auditInitWithTitleMessageDelegateButtonTitlesMethod];
     [LTTAlertViewAuditor auditShowMethod];
 
 __Step 2__ Invoke your method that displays an alert view
 
 __Step 3__ Check that an alert view is initialized as you expected
 
     UIAlertView *alertView = [LTTAlertViewAuditor initializedAlertView];
     XCTAssertEqualObjects([LTTAlertViewAuditor initializationTitle],
                           <#title#>,
                           @"The alert title should be <#title#>");
     XCTAssertEqualObjects([LTTAlertViewAuditor initializationMessage],
                           <#message#>,
                           @"The alert message should be <#message#>");
     XCTAssertEqualObjects([LTTAlertViewAuditor initializationDelegate],
                           <#delegate#>,
                           @"The delegate should be <#delegateDescription#>");
     XCTAssertEqualObjects([LTTAlertViewAuditor initializationCancelTitle],
                           <#cancelButtonTitle#>,
                           @"The cancel button title should be <#cancelButtonTitle#>");
     NSArray *expectedTitles = @[<#otherButtonTitleOne#>,
                                 <#otherButtonTitleTwo#>,
                                 <#otherButtonTitleThree#>];
     XCTAssertEqualObjects([LTTAlertViewAuditor initializationOtherTitles],
                           expectedTitles,
                           @"The other button titles should be <#otherButtonTitleOne#>, \
                           <#otherButtonTitleTwo#> and <#otherButtonTitleThree#>");
 
 __Step 4__ Check that the alert view is shown
 
     XCTAssertEqualObjects([LTTActionSheetAuditor actionSheetToShowFromTabBar],
                           actionSheet,
                           @"The alert view should be shown");
 
 __Step 5__ End auditing of the initialization and display methods
 
     [LTTAlertViewAuditor stopAuditingInitWithTitleMessageDelegateButtonTitlesMethod];
     [LTTAlertViewAuditor stopAuditingShowMethod];

 */

@interface LTTAlertViewAuditor : NSObject

#pragma mark - -initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:

/** @name Initializing an alert view */

/**
 Audits action sheet initialization in order to check the values used
 
 @discussion This method replaces the real method implementation of `-[UIAlertView initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:]` with another method that captures the initialization parameters and returns the alert view to be initialized.
 
 @warning The replacement method DOES NOT call the real method despite returning the object to initialize.
 */
+ (void)auditInitWithTitleMessageDelegateButtonTitlesMethod;

/**
 Ends auditing of alert view initialization and clears captured data
 */
+ (void)stopAuditingInitWithTitleMessageDelegateButtonTitlesMethod;

/**
 @return Alert view being audited
 */
+ (UIAlertView*)initializedAlertView;

/**
 @return Captured initialization title
 */
+ (NSString*)initializationTitle;

/**
 @return Captured initialization message
 */
+ (NSString*)initializationMessage;

/**
 @return Captured alert view delegate
 */
+ (id<UIAlertViewDelegate>)initializationDelegate;

/**
 @return Captured initialization cancel button title
 */
+ (NSString*)initializationCancelTitle;

/**
 @return Captured initialization other button titles
 */
+ (NSArray*)initializationOtherTitles;


#pragma mark - -show

/** @name Displaying an alert view */

/**
 Audits display of alert view
 
 @discussion This method replaces the real method implementation of `-[UIAlertView show]` with another method that captures the passed parameters.
 
 @warning The replacement method DOES NOT call the real method,
 */
+ (void)auditShowMethod;

/**
 Ends auditing of displaying alert views and clears captured data
 */
+ (void)stopAuditingShowMethod;

/**
 @return BOOL indicating whether or not the alert view was shown
 */
+ (BOOL)didShowAlertView;

@end

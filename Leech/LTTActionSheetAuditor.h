//
//  LTTActionSheetAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/21/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 LTTActionSheetAuditor assists in testing code that displays a UIActionSheet
 
 ##Usage
 
 __Step 1__ Begin auditing the initialization and display methods

    [LTTActionSheetAuditor auditInitWithTitleDelegateButtonTitlesMethod];
    [LTTActionSheetAuditor auditShowFromTabBarMethod];
 
 __Step 2__ Invoke your method that displays an action sheet
 
 __Step 3__ Check that an action sheet is initialized as you expected
 
    UIActionSheet *actionSheet = [LTTActionSheetAuditor initializedActionSheet];
    XCTAssertEqualObjects([LTTActionSheetAuditor initializationTitle],
                          <#title#>,
                          @"The sheet title should be <#title#>");
    XCTAssertEqualObjects([LTTActionSheetAuditor initializationDelegate],
                          <#delegate#>,
                          @"The delegate should be <#delegateDescription#>");
    XCTAssertEqualObjects([LTTActionSheetAuditor initializationCancelTitle],
                          <#cancelButtonTitle#>, 
                          @"The cancel button title should be <#cancelButtonTitle#>");
    XCTAssertEqualObjects([LTTActionSheetAuditor initializationDestructTitle], 
                          <#destructiveButtonTitle#>,
                          @"The destructive button title should be <#destructiveButtonTitle#>");
    NSArray *expectedTitles = @[<#otherButtonTitleOne#>,
                                <#otherButtonTitleTwo#>,
                                <#otherButtonTitleThree#>];
    XCTAssertEqualObjects([LTTActionSheetAuditor initializationOtherTitles], 
                          expectedTitles,
                          @"The other button titles should be <#otherButtonTitleOne#>, \
                          <#otherButtonTitleTwo#> and <#otherButtonTitleThree#>");
 
 __Step 4__ Check that the action sheet is shown from a particular tab bar
 
    XCTAssertEqualObjects([LTTActionSheetAuditor actionSheetToShowFromTabBar],
                          actionSheet,
                          @"The action sheet should be shown");
    XCTAssertEqualObjects([LTTActionSheetAuditor tabBarToShowFrom],
                          <#tabBar#>,
                          @"The action sheet should be shown from <#tabBarDescription#>");
 
 __Step 5__ End auditing of the initialization and display methods
 
    [LTTActionSheetAuditor stopAuditingInitWithTitleDelegateButtonTitlesMethod];
    [LTTActionSheetAuditor stopAuditingShowFromTabBarMethod];
 
 */

@interface LTTActionSheetAuditor : NSObject

#pragma mark - -initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:

/** @name Initializing an action sheet */

/**
 Audits action sheet initialization in order to check the values used
 
@discussion This method replaces the real method implementation of `-[UIActionSheet initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:]` with another method that captures the initialization parameters and returns the action sheet to be initialized.
 
 @warning The replacement method DOES NOT call the real method despite returning the object to initialize.
 */
+ (void)auditInitWithTitleDelegateButtonTitlesMethod;

/**
 Ends auditing of action sheet initialization and clears captured data
 */
+ (void)stopAuditingInitWithTitleDelegateButtonTitlesMethod;

/**
 @return Action sheet being audited
 */
+ (UIActionSheet*)initializedActionSheet;

/**
 @return Captured initialization title
 */
+ (NSString*)initializationTitle;

/**
 @return Captured action sheet delegate
 */
+ (id<UIActionSheetDelegate>)initializationDelegate;

/**
 @return Captured initialization cancel button title
 */
+ (NSString*)initializationCancelTitle;

/**
 @return Captured initialization destructive button title
 */
+ (NSString*)initializationDestructTitle;

/**
 @return Captured initialization other button titles
 */
+ (NSArray*)initializationOtherTitles;



#pragma mark - -show

/** @name Displaying an action sheet */

/**
 Audits display of action sheet from tab bars
 
 @discussion This method replaces the real method implementation of `-[UIActionSheet showFromTabBar:]` with another method that captures the passed parameters.
 
 @warning The replacement method DOES NOT call the real method.
 */
+ (void)auditShowFromTabBarMethod;

/**
 Ends auditing of displaying action sheets from tab bars and clears captured data
 */
+ (void)stopAuditingShowFromTabBarMethod;

/**
 @return Captured UIActionSheet to display from a tab bar
 */
+ (UIActionSheet*)actionSheetToShowFromTabBar;

/**
 @return Captured UITabBar from which to display the action sheet
 */
+ (UITabBar*)tabBarToShowFrom;

@end

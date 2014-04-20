//
//  LTTNavigationControllerAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 LTTNavigationControllerAuditor assists in the testing of code that pushes and pops view controllers onto and off of navigation stacks.
 
 ##Usage
 
 ###Pushing a view controller onto the stack
 
 __Step 1__ Begin auditing navigation controller stack pushes
 
     [LTTNavigationControllerAuditor auditPushViewControllerMethod:<#navigationController#> forward:YES];

 __Step 2__ Invoke your method that pushes a new view controller onto the navigation stack
 
 __Step 3__ Check that the appropriate view controller was pushed and that the appropriate animation was used
 
     UIViewController *pushedController = [LTTNavigationControllerAuditor viewControllerToPush:<#navigationController#>];
     //  Check that the view controller matches another controller, is of a certain
     //  class, gets configured properly or any other tests needed
     XCTAssertTrue([LTTNavigationControllerAuditor pushViewControllerAnimatedFlag:<#navigationController#>],
                   @"The push should be animated");
 
 __Step 4__ End auditing of navigation controller stack pushes
 
     [LTTNavigationControllerAuditor stopAuditingPushViewControllerMethod:<#navigationController#>];


 ###Popping a view controller from the stack
 
 __Step 1__ Begin auditing navigation controller stack pops
 
 [LTTNavigationControllerAuditor auditPopViewControllerMethod:<#navigationController#> forward:YES];
 
 __Step 2__ Invoke your method that pops a view controller from the navigation stack
 
 __Step 3__ Check that a view controller was popped and that the appropriate animation was used

      XCTAssertTrue([LTTNavigationControllerAuditor didPopViewController:<#navigationController#>],
                    @"A view controller should be popped from the stack");
      XCTAssertTrue([LTTNavigationControllerAuditor pushViewControllerAnimatedFlag:<#navigationController#>],
                    @"The push should be animated");
 
 __Step 4__ End auditing of navigation controller stack pushes
 
     [LTTNavigationControllerAuditor stopAuditingPopViewControllerMethod:<#navigationController#>];
 */
@interface LTTNavigationControllerAuditor : NSObject

#pragma mark -pushViewController:animated:

/** @name Auditing navigation stack pushes */

/**
 Audits pushing of view controllers onto a navigation stack
 
 @param navController The navigation controller under test
 @param forward BOOL value indicating whether or not the real push method should also be called so that the controller is actually pushed
 
 @discussion This method swaps the real method implementation of `-[UINavigationController pushViewController:animated:]` with another method that captures the view controller to be pushed and the animation flag that is used
 */
+ (void)auditPushViewControllerMethod:(UINavigationController*)navController forward:(BOOL)forward;

/**
 Ends auditing of navigation controller push method and clears captured data
 
 @param auditedController UINavigationController that is being audited
 */
+ (void)stopAuditingPushViewControllerMethod:(UINavigationController*)auditedController;

/**
 Provides the view controller that was captured when trying to push it onto the navigation stack
 
 @return UIViewController object that was attempted to be pushed onto the navigation stack
 
 @param auditedController UINavigationController that is being audited
 */
+ (UIViewController*)viewControllerToPush:(UINavigationController*)auditedController;

/**
 Provides the animation flag that was used when attempting to push a view controller onto the navigation stack
 
 @return BOOL value matching the animated flag
 
 @param auditedController UINavigationController controller that is being audited
 */
+ (BOOL)pushViewControllerAnimatedFlag:(UINavigationController*)auditedController;

#pragma mark -popViewControllerAnimated:

/** @name Auditing navigation stack pops */

/**
 Audits popping of view controllers from a navigation stack
 
 @param navController The navigation controller under test
 @param forward BOOL value indicating whether or not the real pop method should also be called so that the controller is actually popped
 
 @discussion This method swaps the real method implementation of `-[UINavigationController popViewControllerAnimated:]` with another method that captures the call and the animation flag that is used
 */
+ (void)auditPopViewControllerMethod:(UINavigationController*)navController forward:(BOOL)forward;

/**
 Ends auditing of navigation controller push method and clears captured data

 @param auditedController UINavigationController that is being audited
 */
+ (void)stopAuditingPopViewControllerMethod:(UINavigationController*)auditedController;

/**
 Indicates whether or not an attempt was made to pop a view controller from the navigation stack
 
 @return BOOL value indicating whether a pop was attempted
 
 @param auditedController UINavigationController that is being audited
 */
+ (BOOL)didPopViewController:(UINavigationController*)auditedController;

/**
 Provides the animation flag that was used when attempting to pop a view controller from the navigation stack
 
 @return BOOL value matching the animated flag
 
 @param auditedController UINavigationController controller that is being audited
 */
+ (BOOL)popViewControllerAnimatedFlag:(UINavigationController*)auditedController;

@end

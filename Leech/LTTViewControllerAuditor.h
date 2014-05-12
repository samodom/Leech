//
//  LTTViewControllerAuditor.h
//  Leech
//
//  Created by Sam Odom on 2/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

typedef void(^leech_completion_block_t)(void);

@interface LTTViewControllerAuditor : NSObject

/**
 LTTViewControllerAuditor assists in testing view controller superclass calls and transitions
 
 ##General usage
 
 __Step 1__ Begin auditing one or more of the auditable methods
 
 __Step 2__ Invoke your method that performs one or more view controller operation
 
 __Step 3__ Check that the expected operations were called and parameters were used
 
 __Step 4__ End auditing of view controller methods
 
 ##Specific examples
 
 __Checking calls to superclass methods (-viewWillAppear:)__
 
     [LTTViewControllerAuditor auditViewWillAppearMethod:YES];
     [<#controller#> viewWillAppear:YES];
     XCTAssertTrue([LTTViewControllerAuditor didCallSuperViewWillAppear],
                    @"The controller should all its superclass' -viewWillAppear: method");
     XCTAssertTrue([LTTViewControllerAuditor viewWillAppearAnimatedFlag],
                   @"The controller should pass the animated flag to its superclass");
     [LTTViewControllerAuditor stopAuditingViewWillAppearMethod];
 
 __Checking the presentation of a new view controller__
 
     [LTTViewControllerAuditor auditPresentViewControllerMethod:<#controller#> forward:YES];
     //  code that triggers the presentation of another view controller
     UIViewController *presented = [LTTViewControllerAuditor viewControllerToPresent:<#controller#>];
     XCTAssertTrue([presented isKindOfClass:[<#controllerClass#> class]],
                   @"The controller should present a new controller of type <#controllerClass#>");
     //  optionally check to see if the controller is configured appropriately
     XCTAssertTrue([LTTViewControllerAuditor presentViewControllerAnimatedFlag],
                   @"The view controller presentation should be animated");
     leech_completion_block_t completion = [LTTViewControllerAuditor presentViewControllerCompletionBlock:<#controller#>];
     XCTAssertNotNil(completion, @"The controller should use a completion block to perform after presenting the view controller");
     completion();
     //  optionally check to see if post-presentation operations were completely successfully
     [LTTViewControllerAuditor stopAuditingPresentViewControllerMethod:<#controller#>]
 */

#pragma mark - View

#pragma mark -viewDidLoad

/**
 Audits calls to superclass implementation of -viewDidLoad
 
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UIViewController viewDidLoad]` with another method that captures the call and optionally forwards the call to the real method implementation
 */
+ (void)auditViewDidLoadMethod:(BOOL)forward;

/**
 Ends auditing of `viewDidLoad` and clears captured data
 */
+ (void)stopAuditingViewDidLoadMethod;

/**
 Indicates whether or not the superclass implementation of -viewDidLoad was called
 
 @return BOOL indicating whether or not the superclass method was invoked
 */
+ (BOOL)didCallSuperViewDidLoad;

#pragma mark -viewWillAppear:

/**
 Audits calls to superclass implementation of -viewWillAppear:
 
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UIViewController viewWillAppear:]` with another method that captures the call and optionally forwards the call to the real method implementation
 */
+ (void)auditViewWillAppearMethod:(BOOL)forward;

/**
 Ends auditing of `viewWillAppear:` and clears captured data
 */
+ (void)stopAuditingViewWillAppearMethod;

/**
 Indicates whether or not the superclass implementation of -viewWillAppear: was called
 
 @return BOOL indicating whether or not the superclass method was invoked
 */
+ (BOOL)didCallSuperViewWillAppear;

/**
 Provides the captured animation flag to the superclass call of -viewWillAppear:
 
 @return BOOL indicating whether or not the operation is animated
 */
+ (BOOL)viewWillAppearAnimatedFlag;

#pragma mark -viewDidAppear:

/**
 Audits calls to superclass implementation of -viewDidAppear:
 
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UIViewController viewDidAppear:]` with another method that captures the call and optionally forwards the call to the real method implementation
 */
+ (void)auditViewDidAppearMethod:(BOOL)forward;

/**
 Ends auditing of `viewDidAppear:` and clears captured data
 */
+ (void)stopAuditingViewDidAppearMethod;

/**
 Indicates whether or not the superclass implementation of -viewDidAppear: was called
 
 @return BOOL indicating whether or not the superclass method was invoked
 */
+ (BOOL)didCallSuperViewDidAppear;

/**
 Provides the captured animation flag to the superclass call of -viewDidAppear:
 
 @return BOOL indicating whether or not the operation is animated
 */
+ (BOOL)viewDidAppearAnimatedFlag;

#pragma mark -viewWillDisappear:

/**
 Audits calls to superclass implementation of -viewWillDisappear:
 
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UIViewController viewWillDisappear:]` with another method that captures the call and optionally forwards the call to the real method implementation
 */
+ (void)auditViewWillDisappearMethod:(BOOL)forward;

/**
 Ends auditing of `viewWillDisappear:` and clears captured data
 */
+ (void)stopAuditingViewWillDisappearMethod;

/**
 Indicates whether or not the superclass implementation of -viewWillDisappear: was called
 
 @return BOOL indicating whether or not the superclass method was invoked
 */
+ (BOOL)didCallSuperViewWillDisappear;

/**
 Provides the captured animation flag to the superclass call of -viewWillDisappear:
 
 @return BOOL indicating whether or not the operation is animated
 */
+ (BOOL)viewWillDisappearAnimatedFlag;

#pragma mark -viewDidDisappear:

/**
 Audits calls to superclass implementation of -viewDidDisappear:
 
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UIViewController viewDidDisappear:]` with another method that captures the call and optionally forwards the call to the real method implementation
 */
+ (void)auditViewDidDisappearMethod:(BOOL)forward;

/**
 Ends auditing of `viewDidDisappear:` and clears captured data
 */
+ (void)stopAuditingViewDidDisappearMethod;

/**
 Indicates whether or not the superclass implementation of -viewDidDisappear: was called
 
 @return BOOL indicating whether or not the superclass method was invoked
 */
+ (BOOL)didCallSuperViewDidDisappear;

/**
 Provides the captured animation flag to the superclass call of -viewDidDisappear
 
 @return BOOL indicating whether or not the operation is animated
 */
+ (BOOL)viewDidDisappearAnimatedFlag;


#pragma mark - Present/Dismiss view controller

#pragma mark -presentViewController:animated:completion:

+ (void)auditPresentViewControllerMethod:(UIViewController*)viewController forward:(BOOL)forward;
+ (void)stopAuditingPresentViewControllerMethod:(UIViewController*)auditedController;
+ (UIViewController*)viewControllerToPresent:(UIViewController*)auditedController;
+ (BOOL)presentViewControllerAnimatedFlag:(UIViewController*)auditedController;
+ (leech_completion_block_t)presentViewControllerCompletionBlock:(UIViewController*)auditedController;

#pragma mark -dismissViewControllerAnimated:completion:

+ (void)auditDismissViewControllerMethod:(UIViewController*)viewController forward:(BOOL)forward;
+ (void)stopAuditingDismissViewControllerMethod:(UIViewController*)auditedController;
+ (BOOL)dismissViewControllerAnimatedFlag:(UIViewController*)auditedController;
+ (leech_completion_block_t)dismissViewControllerCompletionBlock:(UIViewController*)auditedController;

@end

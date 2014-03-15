//
//  LTTViewControllerAuditor.h
//  Leech
//
//  Created by Sam Odom on 2/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

typedef void(^leech_completion_block_t)(void);

@interface LTTViewControllerAuditor : NSObject

#pragma mark - View

#pragma mark -viewDidLoad

+ (void)auditViewDidLoadMethod:(BOOL)forward;
+ (void)stopAuditingViewDidLoadMethod;
+ (BOOL)didCallSuperViewDidLoad;

#pragma mark -viewWillAppear:

+ (void)auditViewWillAppearMethod:(BOOL)forward;
+ (void)stopAuditingViewWillAppearMethod;
+ (BOOL)didCallSuperViewWillAppear;
+ (BOOL)viewWillAppearAnimatedFlag;

#pragma mark -viewDidAppear:

+ (void)auditViewDidAppearMethod:(BOOL)forward;
+ (void)stopAuditingViewDidAppearMethod;
+ (BOOL)didCallSuperViewDidAppear;
+ (BOOL)viewDidAppearAnimatedFlag;

#pragma mark -viewWillDisappear:

+ (void)auditViewWillDisappearMethod:(BOOL)forward;
+ (void)stopAuditingViewWillDisappearMethod;
+ (BOOL)didCallSuperViewWillDisappear;
+ (BOOL)viewWillDisappearAnimatedFlag;

#pragma mark -viewDidDisappear:

+ (void)auditViewDidDisappearMethod:(BOOL)forward;
+ (void)stopAuditingViewDidDisappearMethod;
+ (BOOL)didCallSuperViewDidDisappear;
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

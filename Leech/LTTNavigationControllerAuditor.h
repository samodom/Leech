//
//  LTTNavigationControllerAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTNavigationControllerAuditor : NSObject

#pragma mark -pushViewController:animated:

+ (void)auditPushViewControllerMethod:(UINavigationController*)navController forward:(BOOL)forward;
+ (void)stopAuditingPushViewControllerMethod:(UINavigationController*)auditedController;
+ (UIViewController*)viewControllerToPush:(UINavigationController*)auditedController;
+ (BOOL)pushViewControllerAnimatedFlag:(UINavigationController*)auditedController;

#pragma mark -popViewControllerAnimated:

+ (void)auditPopViewControllerMethod:(UINavigationController*)navController forward:(BOOL)forward;
+ (void)stopAuditingPopViewControllerMethod:(UINavigationController*)auditedController;
+ (BOOL)didPopViewController:(UINavigationController*)auditedController;
+ (BOOL)popViewControllerAnimatedFlag:(UINavigationController*)auditedController;

@end

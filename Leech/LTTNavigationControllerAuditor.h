//
//  LTTNavigationControllerAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTNavigationControllerAuditor : NSObject

#pragma mark - Push view controller

+ (void)auditPushViewControllerMethod:(BOOL)forward;
+ (void)stopAuditingPushViewControllerMethod:(UINavigationController*)auditedController;
+ (UIViewController*)viewControllerToPush:(UINavigationController*)auditedController;
+ (BOOL)pushViewControllerAnimatedFlag:(UINavigationController*)auditedController;

@end

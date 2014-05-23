//
//  LTTPopoverControllerAuditor.h
//  Leech
//
//  Created by Sam Odom on 5/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTPopoverControllerAuditor : NSObject

+ (void)auditInitWithContentViewControllerMethod;
+ (void)stopAuditingInitWithContentViewControllerMethod;
+ (UIPopoverController*)initializedPopoverController;
+ (UIViewController*)initializationContentViewController;

+ (void)auditPresentFromRectMethod:(UIPopoverController*)popoverController;
+ (void)stopAuditingPresentFromRectMethod:(UIPopoverController*)auditedController;
+ (CGRect)rectFromWhichToPresentPopover:(UIPopoverController*)auditedController;
+ (UIView*)viewInWhichToPresentPopover:(UIPopoverController*)auditedController;

+ (void)auditPresentFromBarButtonMethod:(UIPopoverController*)auditedController;
+ (void)stopAuditingPresentFromBarButtonMethod:(UIPopoverController*)auditedController;
+ (UIBarButtonItem*)barButtonItemFromWhichToPresentPopover:(UIPopoverController*)auditedController;

+ (UIPopoverArrowDirection)arrowDirectionsForPopover:(UIPopoverController*)auditedController;
+ (BOOL)presentPopoverAnimationFlag:(UIPopoverController*)auditedController;

+ (void)auditDismissPopoverAnimatedMethod:(UIPopoverController*)auditedController;
+ (void)stopAuditingDismissPopoverAnimatedMethod:(UIPopoverController*)auditedController;
+ (BOOL)dismissPopoverAnimationFlag:(UIPopoverController*)auditedController;

@end

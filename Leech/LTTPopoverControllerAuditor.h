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

+ (void)auditPresentFromRectMethod;
+ (void)stopAuditingPresentFromRectMethod;
+ (CGRect)rectFromWhichToPresentPopover;
+ (UIView*)viewInWhichToPresentPopover;

+ (void)auditPresentFromBarButtonMethod;
+ (void)stopAuditingPresentFromBarButtonMethod;
+ (UIBarButtonItem*)barButtonItemFromWhichToPresentPopover;

+ (UIPopoverArrowDirection)arrowDirectionsForPopover;
+ (BOOL)presentPopoverAnimationFlag;

+ (void)auditDismissPopoverAnimatedMethod;
+ (void)stopAuditingDismissPopoverAnimatedMethod;
+ (BOOL)dismissPopoverAnimationFlag;

@end

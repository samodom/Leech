//
//  LTTViewControllerAuditor.h
//  Leech
//
//  Created by Sam Odom on 2/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end

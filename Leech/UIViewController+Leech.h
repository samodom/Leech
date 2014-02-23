//
//  UIViewController+Leech.h
//  Leech
//
//  Created by Sam Odom on 2/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Leech)

#pragma mark - View

+ (void)auditViewDidLoadMethod:(BOOL)forward;
+ (void)stopAuditingViewDidLoadMethod;
- (BOOL)didCallSuperViewDidLoad;

+ (void)auditViewWillAppearMethod:(BOOL)forward;
+ (void)stopAuditingViewWillAppearMethod;
- (BOOL)didCallSuperViewWillAppear;
- (BOOL)viewWillAppearAnimatedFlag;

+ (void)auditViewDidAppearMethod:(BOOL)forward;
+ (void)stopAuditingViewDidAppearMethod;
- (BOOL)didCallSuperViewDidAppear;
- (BOOL)viewDidAppearAnimatedFlag;

+ (void)auditViewWillDisappearMethod:(BOOL)forward;
+ (void)stopAuditingViewWillDisappearMethod;
- (BOOL)didCallSuperViewWillDisappear;
- (BOOL)viewWillDisappearAnimatedFlag;

+ (void)auditViewDidDisappearMethod:(BOOL)forward;
+ (void)stopAuditingViewDidDisappearMethod;
- (BOOL)didCallSuperViewDidDisappear;
- (BOOL)viewDidDisappearAnimatedFlag;


#pragma mark - Auditing cleanup

- (void)clearAuditData;

@end

//
//  LTTViewAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/20/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTViewAuditor : NSObject

/**
 LTTViewAuditor assists in testing custom view code by auditing the superclass -awakeFromNib and -layoutSubviews method calls
 
 ##Usage
 
 __Step 1__ Begin auditing the -awakeFromNib or -layoutSubviews method
 
     [LTTViewAuditor auditAwakeFromNibMethod];
 OR
     [LTTViewAuditor auditLayoutSubviewsMethod];

 __Step 2__ Invoke your view's -awakeFromNib or -layoutSubviews method
 
     [<#view#> awakeFromNib];
 OR
     [<#view#> layoutSubviews];

 __Step 3__ Check that the method was called
 
     XCTAssertTrue([LTTViewAuditor didCallSuperAwakeFromNib], @"The view should call its superclass' -awakeFromNib method");
 OR
     XCTAssertTrue([LTTViewAuditor didCallSuperLayoutSubviews], @"The view should call its superclass' -layoutSubviews method");

 __Step 3__ End auditing of -awakeFromNib or -layoutSubviews method
 
     [LTTViewAuditor stopAuditingAwakeFromNibMethod];
 OR
     [LTTViewAuditor stopAuditingAwakeFromNibMethod];

 */
#pragma mark - Superclass calls

/**
 Audits calls to the superclass method -awakeFromNib on UIView
 
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UIView awakeFromNib]` with another method that captures the call to awake and optionally forwards the call to the real method implementation
 */
+ (void)auditAwakeFromNibMethod:(BOOL)forward;

/**
 Ends auditing of `awakeFromNib` and clears captured data
 */
+ (void)stopAuditingAwakeFromNibMethod;

/**
 Indicates whether or not the view's superclass' -awakeFromNib method was called
 
 @return BOOL indicating whether or not the view's superclass' -awakeFromNib method was called
 */
+ (BOOL)didCallSuperAwakeFromNib;


/**
 Audits calls to the superclass method -layoutSubviews on UIView

 @param forward BOOL specifying whether or not to forward the call to the real method implementation

 @discussion This method replaces the real method implementation of `-[UIView layoutSubviews]` with another method that captures the call to layout and optionally forwards the call to the real method implementation
 */
+ (void)auditLayoutSubviewsMethod:(BOOL)forward;

/**
 Ends auditing of `layoutSubviews` and clears captured data
 */
+ (void)stopAuditingLayoutSubviewsMethod;

/**
 Indicates whether or not the view's superclass' -layoutSubviews method was called

 @return BOOL indicating whether or not the view's superclass' -layoutSubviews method was called
 */
+ (BOOL)didCallSuperLayoutSubviews;

@end

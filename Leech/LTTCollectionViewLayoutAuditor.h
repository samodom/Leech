//
//  LTTCollectionViewLayoutAuditor.h
//  Leech
//
//  Created by Sam Odom on 5/12/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 LTTCollectionViewLayoutAuditor assists in subclasses of UICollectionViewLayout
 
 ##General usage
 
 __Step 1__ Begin auditing one of the auditable methods
 
 __Step 2__ Invoke your method that should call a superclass method
 
 __Step 3__ Check that the expected methods were called and parameters were used
 
 __Step 4__ End auditing of methods
 
 ##Specific examples
 
 __Auditing of -layoutAttributesForElementsInRect:__
 
      [LTTCollectionViewLayoutAuditor auditLayoutAttributesForElementsInRectMethods];
      CGRect visibleRect = CGRectMake(0, 0, 120, 120);
      [<#layout#> layoutAttributesForElementsInRect:visibleRect];
      XCTAssertTrue([LTTCollectionViewLayoutAuditor didCallSuperLayoutAttributesForElementsInRect], @"The layout should call its superclass' -layoutAttributesForElementsInRect: method");
      CGRect auditedRect = [LTTCollectionViewLayoutAuditor rectForLayoutAttributes];
      XCTAssertTrue(CGRectEqualToRect(auditedRect, visibleRect, @"The rect should be passed to the superclass");
      [LTTCollectionViewLayoutAuditor stopAuditingLayoutAttributesForElementsInRectMethods];
 
 __Auditing of -layoutAttributesForItemAtIndexPath:__
 
      [LTTCollectionViewLayoutAuditor auditLayoutAttributesForItemAtIndexPathMethods];
      NSIndexPath *samplePath = [NSIndexPath indexPathForItem:1 inSection:2]
      [<#layout#> layoutAttributesForItemAtIndexPath:samplePath];
      XCTAssertTrue([LTTCollectionViewLayoutAuditor didCallSuperLayoutAttributesForItemAtIndexPath], @"The layout should all its superclass' -layoutAttributesForItemAtIndexPath: method");
      NSIndexPath *auditedPath = [LTTCollectionViewLayoutAuditor indexPathForLayoutAttributes];
      XCTAssertEqualObjects(auditedPath, samplePath, @"The index path should be passed to the superclass");
      [LTTCollectionViewLayoutAuditor stopAuditingLayoutAttributesForItemAtIndexPathMethods];

 */
 

@interface LTTCollectionViewLayoutAuditor : NSObject

+ (void) auditLayoutAttributesForElementsInRectMethods;
+ (void) stopAuditingLayoutAttributesForElementsInRectMethods;
+ (BOOL) didCallSuperLayoutAttributesForElementsInRect;
+ (CGRect) rectForLayoutAttributes;

+ (void) auditLayoutAttributesForItemAtIndexPathMethods;
+ (void) stopAuditingLayoutAttributesForItemAtIndexPathMethods;
+ (BOOL) didCallSuperLayoutAttributesForItemAtIndexPath;
+ (NSIndexPath*) indexPathForLayoutAttributes;

@end

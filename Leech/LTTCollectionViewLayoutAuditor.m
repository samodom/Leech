//
//  LTTCollectionViewLayoutAuditor.m
//  Leech
//
//  Created by Sam Odom on 5/12/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTCollectionViewLayoutAuditor.h"

#import "LTTMethodSwizzler.h"

const char *DidCallSuperLayoutAttributesForElementsInRect = "DidCallSuperLayoutAttributesForElementsInRect";
const char *RectForLayoutAttributes = "RectForLayoutAttributes";

const char *DidCallSuperLayoutAttributesForItemsAtIndexPath = "DidCallSuperLayoutAttributesForItemsAtIndexPath";
const char *IndexPathForLayoutAttributes = "IndexPathForLayoutAttributes";

////////////////////////////////////////////////////////////////////////////////
//  Category on UICollectionViewLayout
////////////////////////////////////////////////////////////////////////////////

@implementation UICollectionViewLayout (Leech)

- (NSArray *)Leech_LayoutAttributesForElementsInRect:(CGRect)rect {
    objc_setAssociatedObject([LTTCollectionViewLayoutAuditor class], DidCallSuperLayoutAttributesForElementsInRect, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTCollectionViewLayoutAuditor class], RectForLayoutAttributes, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
    
    return [self Leech_LayoutAttributesForElementsInRect:rect];  //  this will invoke the real method
}

- (UICollectionViewLayoutAttributes *)Leech_LayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject([LTTCollectionViewLayoutAuditor class], DidCallSuperLayoutAttributesForItemsAtIndexPath, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTCollectionViewLayoutAuditor class], IndexPathForLayoutAttributes, indexPath, OBJC_ASSOCIATION_RETAIN);
    
    return [self Leech_LayoutAttributesForItemAtIndexPath:indexPath];  //  this will invoke the real method
}

@end

////////////////////////////////////////////////////////////////////////////////
//  Collection View Layout Auditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTCollectionViewLayoutAuditor

+ (void)auditLayoutAttributesForElementsInRectMethods {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UICollectionViewLayout class] selectorOne:@selector(layoutAttributesForElementsInRect:) selectorTwo:@selector(Leech_LayoutAttributesForElementsInRect:)];
}

+ (void)stopAuditingLayoutAttributesForElementsInRectMethods {
    objc_setAssociatedObject([LTTCollectionViewLayoutAuditor class], DidCallSuperLayoutAttributesForElementsInRect, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([LTTCollectionViewLayoutAuditor class], RectForLayoutAttributes, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UICollectionViewLayout class] selectorOne:@selector(layoutAttributesForElementsInRect:) selectorTwo:@selector(Leech_LayoutAttributesForElementsInRect:)];
}

+ (BOOL)didCallSuperLayoutAttributesForElementsInRect {
    NSNumber *superCalled = objc_getAssociatedObject([LTTCollectionViewLayoutAuditor class], DidCallSuperLayoutAttributesForElementsInRect);
    return superCalled.boolValue;
}

+ (CGRect)rectForLayoutAttributes {
    NSValue *rectValue = objc_getAssociatedObject([LTTCollectionViewLayoutAuditor class], RectForLayoutAttributes);
    return rectValue.CGRectValue;
}

+ (void)auditLayoutAttributesForItemAtIndexPathMethods {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UICollectionViewLayout class] selectorOne:@selector(layoutAttributesForItemAtIndexPath:) selectorTwo:@selector(Leech_LayoutAttributesForItemAtIndexPath:)];
}

+ (void)stopAuditingLayoutAttributesForItemAtIndexPathMethods {
    objc_setAssociatedObject([LTTCollectionViewLayoutAuditor class], DidCallSuperLayoutAttributesForItemsAtIndexPath, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([LTTCollectionViewLayoutAuditor class], IndexPathForLayoutAttributes, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UICollectionViewLayout class] selectorOne:@selector(layoutAttributesForItemAtIndexPath:) selectorTwo:@selector(Leech_LayoutAttributesForItemAtIndexPath:)];
}

+ (BOOL)didCallSuperLayoutAttributesForItemAtIndexPath {
    NSNumber *superCalled = objc_getAssociatedObject([LTTCollectionViewLayoutAuditor class], DidCallSuperLayoutAttributesForItemsAtIndexPath);
    return superCalled.boolValue;
}

+ (NSIndexPath *)indexPathForLayoutAttributes {
    return objc_getAssociatedObject([LTTCollectionViewLayoutAuditor class], IndexPathForLayoutAttributes);
}

@end

//
//  TestCollectionViewLayout.m
//  Leech
//
//  Created by Sam Odom on 5/12/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "TestCollectionViewLayout.h"

@implementation TestCollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    return attributes;
}

@end

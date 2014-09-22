//
//  NSObject+Association.h
//  PWTesting
//
//  Created by Sam Odom on 9/2/14.
//  Copyright (c) 2014 Phunware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Association)

- (void)associateKey:(const void *)key withValue:(id)value;
- (id)associationForKey:(const void *)key;
- (id)dissociateKey:(const void *)key;

@end

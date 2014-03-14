//
//  LTTMockTextField.h
//  Leech
//
//  Created by Sam Odom on 3/13/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTMockTextField : NSObject

- (BOOL)wasAskedToBecomeFirstResponder;
- (BOOL)wasAskedToResignFirstResponder;

@end

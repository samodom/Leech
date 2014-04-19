//
//  LTTMockTextField.h
//  Leech
//
//  Created by Sam Odom on 3/13/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Mock object representing a UITextField
 */
@interface LTTMockTextField : NSObject

/**
 @return BOOL value indicating whether or not the text field was asked to assume first responder status
 */
- (BOOL)wasAskedToBecomeFirstResponder;

/**
 @return BOOL value indicating whether or not the text field was asked to resign first responder status
 */
- (BOOL)wasAskedToResignFirstResponder;

@end

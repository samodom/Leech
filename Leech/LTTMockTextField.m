//
//  LTTMockTextField.m
//  Leech
//
//  Created by Sam Odom on 3/13/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTMockTextField.h"

@implementation LTTMockTextField {
    BOOL wasAskedToBecomeFirstResponder;
    BOOL wasAskedToResignFirstResponder;
}

#pragma mark - First responder

- (void)becomeFirstResponder {
    wasAskedToBecomeFirstResponder = YES;
}

- (BOOL)wasAskedToBecomeFirstResponder {
    return wasAskedToBecomeFirstResponder;
}

- (void)resignFirstResponder {
    wasAskedToResignFirstResponder = YES;
}

- (BOOL)wasAskedToResignFirstResponder {
    return wasAskedToResignFirstResponder;
}

@end

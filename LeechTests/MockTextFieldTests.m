//
//  MockTextFieldTests.m
//  Leech
//
//  Created by Sam Odom on 3/13/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTMockTextField.h"

@interface MockTextFieldTests : XCTestCase

@end

@implementation MockTextFieldTests {
    LTTMockTextField *field;
}

- (void)setUp {
    [super setUp];

    field = [LTTMockTextField new];
}

- (void)tearDown {
    field = nil;

    [super tearDown];
}

- (void)testCanCreateMockTextField {
    XCTAssertTrue([field isKindOfClass:[LTTMockTextField class]], @"Should be able to create a new mock text field");
}

- (void)testFieldIndicatesBeingAskedToBecomeFirstResponder {
    XCTAssertFalse([field wasAskedToBecomeFirstResponder], @"By default the field should not indicate having been asked");
    [(UITextField*)field becomeFirstResponder];
    XCTAssertTrue([field wasAskedToBecomeFirstResponder], @"The field should indicate having been asked to become first responder");
}

- (void)testFieldIndicatesBeingAskedToResignFirstResponderStatus {
    XCTAssertFalse([field wasAskedToResignFirstResponder], @"By default the field should not indicate having been asked");
    [(UITextField*)field resignFirstResponder];
    XCTAssertTrue([field wasAskedToResignFirstResponder], @"The field should indicate having been asked to resign first responder status");
}

@end

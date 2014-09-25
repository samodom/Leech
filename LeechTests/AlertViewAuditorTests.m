//
//  AlertViewAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 3/31/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+
#import "FakeAlertViewDelegate.h"

//  Production
#import "LTTAlertViewAuditor.h"

@interface AlertViewAuditorTests : XCTestCase

@end

@implementation AlertViewAuditorTests {
    UIAlertView *alert;
}

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    alert = nil;

    [super tearDown];
}

- (void)testAuditingOfInitWithTitleMessageDelegateButtonTitlesMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIAlertView class], @selector(initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:)));
    [LTTAlertViewAuditor auditInitWithTitleMessageDelegateButtonTitlesMethod];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIAlertView class], @selector(initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    id<UIAlertViewDelegate> fakeDelegate = [FakeAlertViewDelegate new];
    alert = [[UIAlertView alloc] initWithTitle:@"Alert title" message:@"Message" delegate:fakeDelegate cancelButtonTitle:@"Cancel" otherButtonTitles:@"Other title one", @"Other title two", nil];
    UIAlertView *auditedAlert = [LTTAlertViewAuditor initializedAlertView];
    XCTAssertEqualObjects(auditedAlert, alert, @"The initialized alert view should be captured");
    XCTAssertEqualObjects([LTTAlertViewAuditor initializationTitle], @"Alert title", @"The alert title should be captured");
    XCTAssertEqualObjects([LTTAlertViewAuditor initializationMessage], @"Message", @"The message should be captured");
    XCTAssertEqualObjects([LTTAlertViewAuditor initializationDelegate], fakeDelegate, @"The delegate should be captured");
    XCTAssertEqualObjects([LTTAlertViewAuditor initializationCancelTitle], @"Cancel", @"The cancel button title should be captured");
    NSArray *expected = @[@"Other title one", @"Other title two"];
    XCTAssertEqualObjects([LTTAlertViewAuditor initializationOtherTitles], expected, @"The other button titles should be captured");
    [LTTAlertViewAuditor stopAuditingInitWithTitleMessageDelegateButtonTitlesMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIAlertView class], @selector(initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfShowMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIAlertView class], @selector(show)));
    [LTTAlertViewAuditor auditShowMethod];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIAlertView class], @selector(show)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    alert = [[UIAlertView alloc] initWithTitle:@"Alert title" message:@"Message" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Other title one", @"Other title two", nil];
    [alert show];
    XCTAssertTrue([LTTAlertViewAuditor didShowAlertView], @"The alert view showing should be captured");
    [LTTAlertViewAuditor stopAuditingShowMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIAlertView class], @selector(show)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testCapturingAlertFromShowMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIAlertView class], @selector(show)));
    [LTTAlertViewAuditor captureAlertToShow];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIAlertView class], @selector(show)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The -show method should be swizzled");
    alert = [[UIAlertView alloc] initWithTitle:@"Alert title" message:@"Message" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Other title one", @"Other title two", nil];
    [alert show];
    UIAlertView *shownAlert = [LTTAlertViewAuditor alertToShow];
    XCTAssertEqualObjects(shownAlert, alert, @"The alert to show should be captured");
    [LTTAlertViewAuditor stopCapturingAlertToShow];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIAlertView class], @selector(show)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");

}

@end

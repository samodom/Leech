//
//  PopoverControllerAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 5/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+
#import "TestViewController.h"

//  Production
#import "LTTPopoverControllerAuditor.h"


@interface PopoverControllerAuditorTests : XCTestCase

@end

@implementation PopoverControllerAuditorTests {
    
}

- (void)setUp {
    [super setUp];

}

- (void)tearDown {

    [super tearDown];
}

- (void)testAuditingOfInitWithContentViewControllerMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(initWithContentViewController:)));
    [LTTPopoverControllerAuditor auditInitWithContentViewControllerMethod];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(initWithContentViewController:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    TestViewController *testController = [TestViewController new];
    UIPopoverController *popover = [UIPopoverController alloc];
    UIPopoverController *allocatedPopover = popover;
    popover = [popover initWithContentViewController:testController];
    XCTAssertEqualObjects(popover, allocatedPopover, @"The same popover controller should be returned");
    XCTAssertEqualObjects([LTTPopoverControllerAuditor initializedPopoverController], popover, @"The initialized popover controller should be captured");
    XCTAssertEqualObjects(popover.contentViewController, testController, @"The content controller should be used by the popover");
    XCTAssertEqualObjects([LTTPopoverControllerAuditor initializationContentViewController], testController, @"The initialization content controller should be captured");
    [LTTPopoverControllerAuditor stopAuditingInitWithContentViewControllerMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(initWithContentViewController:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfPresentFromRectMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(presentPopoverFromRect:inView:permittedArrowDirections:animated:)));
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[TestViewController new]];
    [LTTPopoverControllerAuditor auditPresentFromRectMethod:popover];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(presentPopoverFromRect:inView:permittedArrowDirections:animated:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    CGRect rect = CGRectMake(1, 2, 3, 4);
    UIView *view = [UIView new];
    UIPopoverArrowDirection direction = UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionDown;
    [popover presentPopoverFromRect:rect inView:view permittedArrowDirections:direction animated:YES];
    XCTAssertTrue(CGRectEqualToRect([LTTPopoverControllerAuditor rectFromWhichToPresentPopover:popover], rect), @"The rect from which to present the popover should be captured");
    XCTAssertEqualObjects([LTTPopoverControllerAuditor viewInWhichToPresentPopover:popover], view, @"The view in which to present the popover should be captured");
    XCTAssertEqual([LTTPopoverControllerAuditor arrowDirectionsForPopover:popover], direction, @"The arrow directions should be captured");
    XCTAssertTrue([LTTPopoverControllerAuditor presentPopoverAnimationFlag:popover], @"The animated flag should be captured");
    [LTTPopoverControllerAuditor stopAuditingPresentFromRectMethod:popover];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(presentPopoverFromRect:inView:permittedArrowDirections:animated:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfPresentFromBarButtonMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(presentPopoverFromBarButtonItem:permittedArrowDirections:animated:)));
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[TestViewController new]];
    [LTTPopoverControllerAuditor auditPresentFromBarButtonMethod:popover];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(presentPopoverFromBarButtonItem:permittedArrowDirections:animated:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:nil action:NULL];
    UIPopoverArrowDirection direction = UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionDown;
    [popover presentPopoverFromBarButtonItem:button permittedArrowDirections:direction animated:YES];
    XCTAssertEqualObjects([LTTPopoverControllerAuditor barButtonItemFromWhichToPresentPopover:popover], button, @"The bar button item from which to show the popover should be captured");
    XCTAssertEqual([LTTPopoverControllerAuditor arrowDirectionsForPopover:popover], direction, @"The arrow directions should be captured");
    XCTAssertTrue([LTTPopoverControllerAuditor presentPopoverAnimationFlag:popover], @"The animated flag should be captured");
    [LTTPopoverControllerAuditor stopAuditingPresentFromBarButtonMethod:popover];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(presentPopoverFromBarButtonItem:permittedArrowDirections:animated:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfDismissalMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(dismissPopoverAnimated:)));
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[TestViewController new]];
    [LTTPopoverControllerAuditor auditDismissPopoverAnimatedMethod:popover];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(dismissPopoverAnimated:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [popover dismissPopoverAnimated:YES];
    XCTAssertTrue([LTTPopoverControllerAuditor dismissPopoverAnimationFlag:popover], @"The popover dismissal animated flag should be captured");
    [LTTPopoverControllerAuditor stopAuditingDismissPopoverAnimatedMethod:popover];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(dismissPopoverAnimated:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end

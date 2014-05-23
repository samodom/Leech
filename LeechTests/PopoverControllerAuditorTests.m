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
    XCTAssertEqualObjects([LTTPopoverControllerAuditor initiliazedPopoverController], popover, @"The initialized popover controller should be captured");
    XCTAssertEqualObjects(popover.contentViewController, testController, @"The content controller should be used by the popover");
    XCTAssertEqualObjects([LTTPopoverControllerAuditor initializationContentViewController], testController, @"The initialization content controller should be captured");
    [LTTPopoverControllerAuditor stopAuditingInitWithContentViewControllerMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIPopoverController class], @selector(initWithContentViewController:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end

//
//  ActionSheetAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 3/21/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+
#import "FakeActionSheetDelegate.h"

//  Production
#import "LTTActionSheetAuditor.h"

@interface ActionSheetAuditorTests : XCTestCase

@end

@implementation ActionSheetAuditorTests {
    UIActionSheet *sheet;
}

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    sheet = nil;

    [super tearDown];
}

- (void)testAuditingOfInitWithTitleDelegateButtonTitlesMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIActionSheet class], @selector(initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:)));
    [LTTActionSheetAuditor auditInitWithTitleDelegateButtonTitlesMethod];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIActionSheet class], @selector(initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    id<UIActionSheetDelegate> fakeDelegate = [FakeActionSheetDelegate new];
    sheet = [[UIActionSheet alloc] initWithTitle:@"Sheet title" delegate:fakeDelegate cancelButtonTitle:@"Cancel title" destructiveButtonTitle:@"Destruct title" otherButtonTitles:@"Other title one", @"Other title two", nil];
    UIActionSheet *auditedSheet = [LTTActionSheetAuditor initializedActionSheet];
    XCTAssertEqualObjects(auditedSheet, sheet, @"The initialized action sheet should be captured");
    XCTAssertEqualObjects([LTTActionSheetAuditor initializationTitle], @"Sheet title", @"The sheet title should be captured");
    XCTAssertEqualObjects([LTTActionSheetAuditor initializationDelegate], fakeDelegate, @"The delegate should be captured");
    XCTAssertEqualObjects([LTTActionSheetAuditor initializationCancelTitle], @"Cancel title", @"The cancel button title should be captured");
    XCTAssertEqualObjects([LTTActionSheetAuditor initializationDestructTitle], @"Destruct title", @"The destructive button title should be captured");
    NSArray *expected = @[@"Other title one", @"Other title two"];
    XCTAssertEqualObjects([LTTActionSheetAuditor initializationOtherTitles], expected, @"The other button titles should be captured");
    [LTTActionSheetAuditor stopAuditingInitWithTitleDelegateButtonTitlesMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIActionSheet class], @selector(initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfShowFromTabBarMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIActionSheet class], @selector(showFromTabBar:)));
    [LTTActionSheetAuditor auditShowFromTabBarMethod];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIActionSheet class], @selector(showFromTabBar:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    sheet = [[UIActionSheet alloc] initWithTitle:@"Sheet title" delegate:nil cancelButtonTitle:@"Cancel title" destructiveButtonTitle:@"Destruct title" otherButtonTitles:@"Other title one", @"Other title two", nil];
    UITabBar *tabBar = [UITabBar new];
    [sheet showFromTabBar:tabBar];
    XCTAssertEqualObjects([LTTActionSheetAuditor actionSheetToShowFromTabBar], sheet, @"The action sheet to show should be captured");
    XCTAssertEqualObjects([LTTActionSheetAuditor tabBarToShowFrom], tabBar, @"The tab bar from which to show the action sheet should be captured");
    [LTTActionSheetAuditor stopAuditingShowFromTabBarMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIActionSheet class], @selector(showFromTabBar:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end

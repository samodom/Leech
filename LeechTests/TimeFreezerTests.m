//
//  TimeFreezerTests.m
//  Leech
//
//  Created by Sam Odom on 3/2/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTTimeFreezer.h"

@interface TimeFreezerTests : XCTestCase

@end

@implementation TimeFreezerTests {

}

- (void)setUp {
    [super setUp];

}

- (void)tearDown {

    [super tearDown];
}

- (void) testCanFreezeTime {
    NSDate *beforeFreeze = [NSDate date];
    [NSThread sleepForTimeInterval:0.1];
    [LTTTimeFreezer freezeTime];
    NSDate *afterFreeze = [NSDate date];
    XCTAssertTrue([LTTTimeFreezer timeIsFrozen], @"The frozen status should be indicated by the class");
    XCTAssertEqualObjects([beforeFreeze earlierDate:afterFreeze], beforeFreeze, @"The before date should certainly have occurred before the after date, right");
    [NSThread sleepForTimeInterval:0.1];
    NSDate *stillFrozen = [NSDate date];
    XCTAssertEqualObjects(afterFreeze, stillFrozen, @"The date should remain the same if it's really frozen");
    [LTTTimeFreezer unfreezeTime];
}

- (void) testFreezingAndUnfreezingTimeSwizzlesDateMethods {
    IMP realImplementation = method_getImplementation(class_getClassMethod([NSDate class], @selector(date)));
    [LTTTimeFreezer freezeTime];
    IMP currentImplementation = method_getImplementation(class_getClassMethod([NSDate class], @selector(date)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [LTTTimeFreezer unfreezeTime];
    currentImplementation = method_getImplementation(class_getClassMethod([NSDate class], @selector(date)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void) testCannotFreezeTimeOnceFrozen {
    [LTTTimeFreezer freezeTime];
    XCTAssertThrows([LTTTimeFreezer freezeTime], @"Trying to freeze time after it has been frozen is a programming error");
    [LTTTimeFreezer unfreezeTime];
}

- (void) testFrozenDateCanBeSet {
    NSDate *date = [NSDate distantFuture];
    [LTTTimeFreezer freezeTime];
    [LTTTimeFreezer setFrozenDate:date];
    XCTAssertEqualObjects([NSDate date], date, @"The provided frozen time should now be used");
    [LTTTimeFreezer unfreezeTime];
}

- (void) testCanUnfreezeTime {
    [LTTTimeFreezer freezeTime];
    NSDate *frozenTime = [NSDate date];
    [NSThread sleepForTimeInterval:0.1];
    [LTTTimeFreezer unfreezeTime];
    XCTAssertFalse([LTTTimeFreezer timeIsFrozen], @"The unfrozen status should be indicated by the class");
    NSDate *unfrozenTime = [NSDate date];
    XCTAssertEqualObjects([unfrozenTime laterDate:frozenTime], unfrozenTime, @"Unfrozen time should be later than the frozen time");
}

- (void) testCannotUnfreezeTimeIfNotFrozen {
    XCTAssertThrows([LTTTimeFreezer unfreezeTime], @"Trying to unfreeze time if it has not been frozen is a programming error");
}

@end

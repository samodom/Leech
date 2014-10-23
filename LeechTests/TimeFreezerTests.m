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

IMP implementationOfClassMethod(SEL);

@interface TimeFreezerTests : XCTestCase

@end

@implementation TimeFreezerTests {
    SEL * selectorsToSwizzle;
    IMP * realImplementations;
}

- (void)setUp {
    [super setUp];

    selectorsToSwizzle = malloc(sizeof(IMP) * 2);
    selectorsToSwizzle[0] = @selector(date);
    selectorsToSwizzle[1] = @selector(timeIntervalSinceReferenceDate);
}

- (void)tearDown {
    free(selectorsToSwizzle);

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
    realImplementations = malloc(sizeof(IMP) * 2);
    for (NSUInteger index = 0; index < 2; index++) {
        Method method = class_getClassMethod([NSDate class], selectorsToSwizzle[index]);
        realImplementations[index] = method_getImplementation(method);
    }

    [LTTTimeFreezer freezeTime];
    for (NSUInteger index = 0; index < 2; index++) {
        IMP currentImplementation = implementationOfClassMethod(selectorsToSwizzle[index]);
        XCTAssertNotEqual(currentImplementation, realImplementations[index], @"Each method should be swizzled to a fake implementation");
    }

    [LTTTimeFreezer unfreezeTime];
    for (NSUInteger index = 0; index < 2; index++) {
        IMP currentImplementation = implementationOfClassMethod(selectorsToSwizzle[index]);
        XCTAssertEqual(currentImplementation, realImplementations[index], @"Each method should be swizzled back to the original implementation");
    }
}

- (void) testCannotFreezeTimeOnceFrozen {
    [LTTTimeFreezer freezeTime];
    XCTAssertThrows([LTTTimeFreezer freezeTime], @"Trying to freeze time after it has been frozen is a programming error");
    [LTTTimeFreezer unfreezeTime];
}

- (void) testFrozenDateCanBeSet {
    NSDate *date = [NSDate date];
    [LTTTimeFreezer freezeTime];
    [LTTTimeFreezer setFrozenDate:date];
    NSDate *frozenDate = [NSDate date];
    XCTAssertEqualObjects(frozenDate, date, @"The provided frozen time should now be used");
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval expected = [frozenDate timeIntervalSinceReferenceDate];
    XCTAssertEqual(interval, expected, @"The frozen time should be used to calculate the interval");
    [LTTTimeFreezer unfreezeTime];
}

- (void) testCanUnfreezeTime {
    [LTTTimeFreezer freezeTime];
    NSDate *frozenTime = [NSDate date];
    NSTimeInterval frozenInterval = [NSDate timeIntervalSinceReferenceDate];
    [NSThread sleepForTimeInterval:0.1];
    [LTTTimeFreezer unfreezeTime];
    XCTAssertFalse([LTTTimeFreezer timeIsFrozen], @"The unfrozen status should be indicated by the class");
    NSDate *unfrozenTime = [NSDate date];
    XCTAssertEqualObjects([unfrozenTime laterDate:frozenTime], unfrozenTime, @"Unfrozen time should be later than the frozen time");
    NSTimeInterval unfrozenInterval = [NSDate timeIntervalSinceReferenceDate];
    XCTAssertGreaterThan(unfrozenInterval, frozenInterval, @"The unfrozen interval should be greater than the frozen interval");
}

- (void) testCannotUnfreezeTimeIfNotFrozen {
    XCTAssertThrows([LTTTimeFreezer unfreezeTime], @"Trying to unfreeze time if it has not been frozen is a programming error");
}

@end

IMP implementationOfClassMethod(SEL selector) {
    Method method = class_getClassMethod([NSDate class], selector);
    return method_getImplementation(method);
}

//
//  MethodSwizzlingRecordKeeperTests.m
//  Leech
//
//  Created by Sam Odom on 2/16/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LTTMethodSwizzlingRecordKeeper.h"

#import "LTTMethodSwizzlingRecord.h"

#import "SampleSwizzlableClass.h"


LTTMethodSwizzlingRecord * ClassRecord(SEL, SEL);
LTTMethodSwizzlingRecord * InstanceRecord(SEL, SEL);

@interface MethodSwizzlingRecordKeeperTests : XCTestCase

@end

@implementation MethodSwizzlingRecordKeeperTests {
    LTTMethodSwizzlingRecordKeeper *keeper;
    LTTMethodSwizzlingRecord *classRecord, *classRecordCopy, *badClassRecord;
    LTTMethodSwizzlingRecord *instanceRecord, *instanceRecordCopy, *badInstanceRecord;
    SEL realClassSelector, fakeClassSelector;
    SEL realInstanceSelector, fakeInstanceSelector;
}

- (void)setUp {
    [super setUp];

    keeper = [LTTMethodSwizzlingRecordKeeper new];

    realClassSelector = @selector(realClassMethod);
    fakeClassSelector = @selector(fakeClassMethod);
    realInstanceSelector = @selector(realInstanceMethod);
    fakeInstanceSelector = @selector(fakeInstanceMethod);

    classRecord = ClassRecord(realClassSelector, fakeClassSelector);
    classRecordCopy = ClassRecord(realClassSelector, fakeClassSelector);
    instanceRecord = InstanceRecord(realInstanceSelector, fakeInstanceSelector);
    instanceRecordCopy = InstanceRecord(realInstanceSelector, fakeInstanceSelector);
}

- (void)tearDown {
    keeper = nil;

    classRecord = nil;
    classRecordCopy = nil;
    badClassRecord = nil;

    instanceRecord = nil;
    badInstanceRecord = nil;

    realClassSelector = nil;
    fakeClassSelector = nil;
    realInstanceSelector = nil;
    fakeInstanceSelector = nil;

    [super tearDown];
}

- (void)testRecordKeeperAcceptsUnacceptedRecords {
    XCTAssertFalse([keeper isClassMethodSwizzledForSelector:realClassSelector], @"The method record should not be accepted yet");
    XCTAssertTrue([keeper acceptMethodSwizzlingRecord:classRecord], @"The method record should be accepted since the keeper has not accepted it yet");
    XCTAssertTrue([keeper isClassMethodSwizzledForSelector:realClassSelector], @"The record keeper should now indicate having the provided method record");

    XCTAssertFalse([keeper isInstanceMethodSwizzledForSelector:realInstanceSelector], @"The method record should not be accepted yet");
    XCTAssertTrue([keeper acceptMethodSwizzlingRecord:instanceRecord], @"The method record should be accepted since the keeper has not accepted it yet");
    XCTAssertTrue([keeper isInstanceMethodSwizzledForSelector:realInstanceSelector], @"The record keeper should now indicate having the provided method record");
}

- (void)testRecordKeeperRejectsPreviouslyAcceptedRecord {
    [keeper acceptMethodSwizzlingRecord:classRecord];
    XCTAssertFalse([keeper acceptMethodSwizzlingRecord:classRecordCopy], @"The method record should not be accepted since the keeper has already accepted it");

    [keeper acceptMethodSwizzlingRecord:instanceRecord];
    XCTAssertFalse([keeper acceptMethodSwizzlingRecord:instanceRecordCopy], @"The method record should not be accepted since the keeper has already accepted it");
}

- (void)testRecordKeeperRejectsRecordWithDifferentRealSelector {
    [keeper acceptMethodSwizzlingRecord:classRecord];
    badClassRecord = ClassRecord(@selector(stringWithFormat:), fakeClassSelector);
    XCTAssertFalse([keeper acceptMethodSwizzlingRecord:classRecordCopy], @"The method record should not be accepted since the keeper has already accepted a record with the same fake selector");

    [keeper acceptMethodSwizzlingRecord:instanceRecord];
    badInstanceRecord = InstanceRecord(@selector(stringWithFormat:), fakeInstanceSelector);
    XCTAssertFalse([keeper acceptMethodSwizzlingRecord:instanceRecordCopy], @"The method record should not be accepted since the keeper has already accepted a record with the same fake selector");
}

- (void)testRecordKeeperRejectsRecordWithDifferentFakeSelector {
    [keeper acceptMethodSwizzlingRecord:classRecord];
    badClassRecord = ClassRecord(realClassSelector, @selector(stringWithFormat:));
    XCTAssertFalse([keeper acceptMethodSwizzlingRecord:classRecordCopy], @"The method record should not be accepted since the keeper has already accepted a record with the same real selector");

    [keeper acceptMethodSwizzlingRecord:instanceRecord];
    badInstanceRecord = InstanceRecord(realInstanceSelector, @selector(stringWithFormat:));
    XCTAssertFalse([keeper acceptMethodSwizzlingRecord:instanceRecordCopy], @"The method record should not be accepted since the keeper has already accepted a record with the same real selector");
}

- (void)testRecordKeeperIgnoresReleasingUnacceptedRecord {
    XCTAssertNoThrow([keeper releaseMethodSwizzlingRecord:classRecord], @"The record keeper should ignore calls to release an unknown method record");
    XCTAssertNoThrow([keeper releaseMethodSwizzlingRecord:instanceRecord], @"The record keeper should ignore calls to release an unknown method record");
}

- (void)testRecordKeeperReleasesAcceptedRecord {
    [keeper acceptMethodSwizzlingRecord:classRecord];
    [keeper releaseMethodSwizzlingRecord:classRecordCopy];
    XCTAssertFalse([keeper hasMethodSwizzlingRecord:classRecord], @"The record keeper should release the previously accepted record");

    [keeper acceptMethodSwizzlingRecord:instanceRecord];
    [keeper releaseMethodSwizzlingRecord:instanceRecordCopy];
    XCTAssertFalse([keeper hasMethodSwizzlingRecord:instanceRecord], @"The record keeper should release the previously accepted record");
}

- (void)testRecordKeeperDoesNotReleaseRecordWithDifferentRealSelector {
    [keeper acceptMethodSwizzlingRecord:classRecord];
    badClassRecord = ClassRecord(@selector(stringWithFormat:), fakeClassSelector);
    [keeper releaseMethodSwizzlingRecord:badClassRecord];
    XCTAssertTrue([keeper hasMethodSwizzlingRecord:classRecordCopy], @"The record keeper should not release the record if the real selector is different");

    [keeper acceptMethodSwizzlingRecord:instanceRecord];
    badInstanceRecord = InstanceRecord(@selector(stringWithFormat:), fakeInstanceSelector);
    [keeper releaseMethodSwizzlingRecord:badInstanceRecord];
    XCTAssertTrue([keeper hasMethodSwizzlingRecord:instanceRecordCopy], @"The record keeper should not release the record if the real selector is different");
}

- (void)testRecordKeeperDoesNotReleaseRecordWithDifferentFakeSelector {
    [keeper acceptMethodSwizzlingRecord:classRecord];
    badClassRecord = ClassRecord(realClassSelector, @selector(stringWithFormat:));
    [keeper releaseMethodSwizzlingRecord:badClassRecord];
    XCTAssertTrue([keeper hasMethodSwizzlingRecord:classRecordCopy], @"The record keeper should not release the record if the fake selector is different");

    [keeper acceptMethodSwizzlingRecord:instanceRecord];
    badInstanceRecord = InstanceRecord(realInstanceSelector, @selector(stringWithFormat:));
    [keeper releaseMethodSwizzlingRecord:badInstanceRecord];
    XCTAssertTrue([keeper hasMethodSwizzlingRecord:instanceRecordCopy], @"The record keeper should not release the record if the fake selector is different");
}


@end

LTTMethodSwizzlingRecord * ClassRecord(SEL real, SEL fake) {
    return [LTTMethodSwizzlingRecord classRecordWithRealSelector:real fakeSelector:fake];
}

LTTMethodSwizzlingRecord * InstanceRecord(SEL real, SEL fake) {
    return [LTTMethodSwizzlingRecord instanceRecordWithRealSelector:real fakeSelector:fake];
}

//
//  DeviceTests.m
//  Leech
//
//  Created by Sam Odom on 7/2/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTDeviceAuditor.h"


@interface DeviceTests : XCTestCase

@end

@implementation DeviceTests {
    
}

- (void)setUp {
    [super setUp];

}

- (void)tearDown {

    [super tearDown];
}

- (void)testDeviceIsForcedToPhone {
    UIUserInterfaceIdiom realIdiom = [[UIDevice currentDevice] userInterfaceIdiom];
    [LTTDeviceAuditor forceUserInterfaceIdiom:UIUserInterfaceIdiomPhone];
    XCTAssertEqual([[UIDevice currentDevice] userInterfaceIdiom], UIUserInterfaceIdiomPhone, @"The user interface idiom should be forced to 'phone'");
    [LTTDeviceAuditor stopForcingUserInterfaceIdiom];
    XCTAssertEqual([[UIDevice currentDevice] userInterfaceIdiom], realIdiom, @"The user interface idiom should no longer be forced to 'phone'");
}

- (void)testDeviceIsForcedToPad {
    UIUserInterfaceIdiom realIdiom = [[UIDevice currentDevice] userInterfaceIdiom];
    [LTTDeviceAuditor forceUserInterfaceIdiom:UIUserInterfaceIdiomPad];
    XCTAssertEqual([[UIDevice currentDevice] userInterfaceIdiom], UIUserInterfaceIdiomPad, @"The user interface idiom should be forced to 'pad'");
    [LTTDeviceAuditor stopForcingUserInterfaceIdiom];
    XCTAssertEqual([[UIDevice currentDevice] userInterfaceIdiom], realIdiom, @"The user interface idiom should no longer be forced to 'pad'");
}

@end

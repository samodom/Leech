//
//  LTTMethodSwizzlingRecord.m
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import "LTTMethodSwizzlingRecord+Private.h"
#import "LTTClassMethodSwizzlingRecord.h"
#import "LTTInstanceMethodSwizzlingRecord.h"

@implementation LTTMethodSwizzlingRecord

+ (instancetype)classRecordWithRealSelector:(SEL)realSelector
                               fakeSelector:(SEL)fakeSelector {
    return [[LTTClassMethodSwizzlingRecord alloc] initWithRealSelector:realSelector fakeSelector:fakeSelector];
}

+ (instancetype)instanceRecordWithRealSelector:(SEL)realSelector
                                  fakeSelector:(SEL)fakeSelector {
    return [[LTTInstanceMethodSwizzlingRecord alloc] initWithRealSelector:realSelector fakeSelector:fakeSelector];
}

- (instancetype)initWithRealSelector:(SEL)realSelector
                        fakeSelector:(SEL)fakeSelector {
    self = [super init];
    if (self) {
        _realSelector = realSelector;
        _fakeSelector = fakeSelector;
    }

    return self;
}

@end

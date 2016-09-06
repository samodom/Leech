//
//  LTTMethodSwizzlingRecord.h
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTMethodSwizzlingRecord : NSObject

+ (instancetype)classRecordWithRealSelector:(SEL)realSelector
                               fakeSelector:(SEL)fakeSelector;

+ (instancetype)instanceRecordWithRealSelector:(SEL)realSelector
                                  fakeSelector:(SEL)fakeSelector;

@property (readonly) SEL realSelector;
@property (readonly) SEL fakeSelector;

@end

//
//  HostsFromGroupSigletone.m
//  Network Monitor
//
//  Created by Максим on 14.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "HostsFromGroupSigletone.h"

@implementation HostsFromGroupSigletone

static HostsFromGroupSigletone* _sharedInstance = nil;

//Точка доступа.
+(HostsFromGroupSigletone*)sharedInstance{
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[HostsFromGroupSigletone alloc] init];
        } }
    return _sharedInstance;
}


@end

//
//  HostsFromGroupSigletone.h
//  Network Monitor
//
//  Created by Максим on 14.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostsFromGroupSigletone : NSObject
@property (nonatomic, strong) NSMutableArray *hosts;

+ (HostsFromGroupSigletone*)sharedInstance;
@end

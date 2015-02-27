//
//  HostClaim.m
//  Network Monitor
//
//  Created by Максим on 12.12.14.
//  Copyright (c) 2014 Prigozhenkov Maxim. All rights reserved.
//

#import "HostClaim.h"
#import "ViewController.h"
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>

@implementation HostClaim

@synthesize onlineHost;

NSString *hostAddress = nil;
NSNumber *hostPort = nil;

//Инициализатор
- (id)initWithAddress:(NSString *)address port:(NSNumber *)port
{
    self = [super init];
    if (self) {
        hostAddress = address;
        hostPort = port;
    }
    return self;
}

//Метод проверки доступности хоста
//Пусть метод будет возвращать числовое значение, это поможет избежать ошибок и исключений во время исполнения метода
-(int)claimHostToAddress{
    onlineHost = nil;
    char message[] = "Are you ok?";

    struct sockaddr_in addr;

    addr.sin_family = AF_INET;
    addr.sin_port = htons([hostPort intValue]); // мы работаем на этом порту
    addr.sin_addr.s_addr = inet_addr([[NSString stringWithFormat:@"%@", hostAddress]UTF8String]);
    
    CFSocketRef socket = CFSocketCreate(kCFAllocatorDefault,
                                        PF_INET,
                                        SOCK_STREAM,
                                        IPPROTO_TCP,
                                        kCFSocketNoCallBack,
                                        nil,
                                        nil);

    CFDataRef data = CFDataCreate(nil, message, (strlen(message)+1));
    CFDataRef address = CFDataCreate(nil, (char *)&addr, sizeof(addr));
    
    CFSocketError err = CFSocketConnectToAddress(socket, address, 5);//CFSocketSendData(socket, nil, data, 5);
    
    if (err == kCFSocketSuccess) {
        onlineHost = true;
    }
    else
    {
        onlineHost = false;
    }
    return 0;
}
@end



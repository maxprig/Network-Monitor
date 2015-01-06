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

//Инициализатор
- (id)initWithAddress:(NSString *)address
{
    self = [super init];
    if (self) {
        hostAddress = address;
    }
    return self;
}

//Метод проверки доступности хоста
//Пусть метод будет возвращать числовое значение, это поможет избежать ошибок и исключений во время исполнения метода
-(int)claimHostToAddress{
    onlineHost = nil;
    char message[] = "Hello there!\n";
    char buf[sizeof(message)];
    
    int sock;
    struct sockaddr_in addr;
    struct timeval  tv;
    
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if(sock < 0)
    {
        perror("socket");
        onlineHost = false;
        return 0;
    }
    
    addr.sin_family = AF_INET;
    addr.sin_port = htons(4899); // мы работаем на этом порту
    addr.sin_addr.s_addr = inet_addr([[NSString stringWithFormat:@"%@", hostAddress]UTF8String]);
    tv.tv_sec = 5.0;
    
    if(connect(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0)
    {
        perror("connect");
        onlineHost = false;
        return 0;
    }
    
    send(sock, message, sizeof(message), 0);
    recv(sock, buf, sizeof(message), 0);
    
    printf(buf);
    close(sock);
    if (buf) {
        onlineHost = true;
    }
    return 0;
}
@end

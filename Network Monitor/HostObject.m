//
//  HostObject.m
//  Network Monitor
//
//  Created by Максим on 13.12.14.
//  Copyright (c) 2014 Prigozhenkov Maxim. All rights reserved.
//

#import "HostObject.h"
#import "HostClaim.h"

@implementation HostObject

@synthesize hostStatus;
@synthesize hostAddress;
@synthesize lastTime;
@synthesize lastOnlineTime;
@synthesize lostConnectionWithHostTime;

//Создадим объект класса HostClaim. В инициализаторе позже его создадим, так как с ним придется постоянно работать.
HostClaim *claimToHost = nil;

#pragma mark -Инициализатор-
- (id)initWithAddress:(NSString *)address port:(NSNumber*)port
{
    self = [super init];
    if (self) {
        hostAddress = address;
        hostStatus = false;
        claimToHost = [[HostClaim alloc]initWithAddress:address port:port];
    }
    return self;
}

#pragma mark -Проверка доступности хоста-
-(void)doConnection{
    [claimToHost claimHostToAddress];
    if ([claimToHost onlineHost]) {
        hostStatus = true;
    }else if (![claimToHost onlineHost]){
        //Если нет ответа от хоста, то
        //Будем пытаться повторно соединиться пять раз.
        //Если за пять попыток соединения мы не получим ответа, то хост ушел в оффлайн.
        for (int i = 0; i <= 5; i++) {
            NSLog(@"Попытка соединения №%i", i);
            [claimToHost claimHostToAddress];
            //Проверка, если вдруг очнется
            if ([claimToHost onlineHost]) {
                hostStatus = true;
                break;
            }
            //Если ответ так и не поступил
            if (![claimToHost onlineHost]&& i == 5 ) {
                hostStatus = false;
            }
            sleep(3); //Ожидаем 3 секунды до следующей попытки
        }
    }
}


-(void)notification{
    //Не знаю пока, что тут будет, но пусть будет.
}
@end

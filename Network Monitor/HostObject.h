//
//  HostObject.h
//  Network Monitor
//
//  Created by Максим on 13.12.14.
//  Copyright (c) 2014 Prigozhenkov Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostObject : NSObject

//Значение переменной свидетельствует о доступности хоста
@property (assign) BOOL hostStatus;

//Адрес хоста
@property (assign) 	NSString *hostAddress;

//Время последнего ответа
@property (assign) NSString *lastTime;

//Последнее время, когда хост был доступен
@property (assign) NSString *lastOnlineTime;

//Время потери соединения
@property (assign) NSString *lostConnectionWithHostTime;

-(id)initWithAddress:(NSString *)address port:(NSNumber*)port;

-(void)doConnection;

-(void)notification;

@end

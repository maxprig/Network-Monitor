//
//  HostClaim.h
//  Network Monitor
//
//  Created by Максим on 12.12.14.
//  Copyright (c) 2014 Prigozhenkov Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostClaim : NSObject

//Переменная, которая будет сообщать о доступности хоста в текущий момент времени
@property (assign) BOOL onlineHost;

//Инициализатор
- (id)initWithAddress:(NSString *)address port:(NSNumber)port;

//Сканер
-(int)claimHostToAddress;

@end

//
//  LogHandler.h
//  Network Monitor
//
//  Created by Максим on 29.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogHandler : NSObject
@property (nonatomic, strong) NSMutableArray *logs;
@property (nonatomic, strong) NSString *path;
+(LogHandler*)sharedInstance;
-(void)writeLog:(NSString*)stringLog;
-(void)writeLogInFile:(NSString*)path log:(NSArray*)log;
@end

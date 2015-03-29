//
//  LogHandler.m
//  Network Monitor
//
//  Created by Максим on 29.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "LogHandler.h"

@implementation LogHandler
@synthesize logs;

+(LogHandler*)sharedInstance{
    LogHandler *object = nil;
    if (!object) {
        object = [LogHandler new];
        return object;
    }
    return object;
}

-(void)writeLog:(NSString*)stringLog{
    if (!logs) {
        logs = [NSMutableArray new];
    }
    NSDate *date = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd hh.mm"];
    
    NSString *str = [NSString stringWithFormat:@"%@: %@", [formatter stringFromDate:date], stringLog];
    
    [logs addObject:str];
}

-(void)writeLogInFile:(NSString*)path log:(NSArray*)log{
    NSLog(@"%@", path);
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSString *strLog = nil;
        for (NSString *str in log){
            strLog = [NSString stringWithFormat:@"%@ \n %@", strLog, str];
        }
        [data writeToFile:strLog atomically:YES];
    }
}

#pragma mark -CoreData Methods-


@end

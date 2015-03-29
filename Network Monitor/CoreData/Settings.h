//
//  Settings.h
//  Network Monitor
//
//  Created by Максим on 29.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSManagedObject

@property (nonatomic, retain) NSNumber * controllInternet;
@property (nonatomic, retain) NSNumber * writingLog;
@property (nonatomic, retain) NSString * logPath;

@end

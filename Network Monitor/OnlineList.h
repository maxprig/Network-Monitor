//
//  OnlineList.h
//  Network Monitor
//
//  Created by Максим on 22.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OnlineList : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * port;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * groupId;
@property (nonatomic, retain) NSNumber * online;

@end

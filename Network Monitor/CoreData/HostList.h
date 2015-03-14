//
//  HostList.h
//  Network Monitor
//
//  Created by Максим on 14.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group;

@interface HostList : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * port;
@property (nonatomic, retain) NSSet *groups;
@end

@interface HostList (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end

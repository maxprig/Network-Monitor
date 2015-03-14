//
//  Group.h
//  Network Monitor
//
//  Created by Максим on 14.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HostList;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSNumber * groupID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *hostList;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addHostListObject:(HostList *)value;
- (void)removeHostListObject:(HostList *)value;
- (void)addHostList:(NSSet *)values;
- (void)removeHostList:(NSSet *)values;

@end

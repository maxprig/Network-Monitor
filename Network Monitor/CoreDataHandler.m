//
//  CoreDataHandler.m
//  Network Monitor
//
//  Created by Максим on 01.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "CoreDataHandler.h"

@implementation CoreDataHandler
/*
+ (CoreDataHandler*)sharedObject
{
    @synchronized(self)
    {
        if (!sHandler) {
            sHandler = [CoreDataHandler new];
        }
    }
    return sHandler;
}

-(instancetype)init
{
    return [self initWithStore:nil];
}

- (instancetype)initWithStore:(RKManagedObjectStore *)store
{
    self = [super init];
    if (self) {
        _managedObjectContext = store.mainQueueManagedObjectContext;
        _persistentStoreManagedObjectContext = store.persistentStoreManagedObjectContext;
    }
    return self;
}*/

@end

//
//  DeleteHostVC.m
//  Network Monitor
//
//  Created by Максим on 30.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "DeleteHostVC.h"
#import "HostList.h"

@interface DeleteHostVC ()

@end

@implementation DeleteHostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *arr = [NSMutableArray new];
    for (HostList *host in [self dataFromCoreData]){
        [arr addObject:host.address];
    }
    [_hostChanger addItemsWithTitles:arr];
}

- (IBAction)pressDeleteButton:(NSButton *)sender {
    NSManagedObjectContext *context = [self takeContext];
    NSString *item = [_hostChanger titleOfSelectedItem];
    NSArray *arr = [self dataFromCoreData];
    for (HostList *host in arr){
        if ([host.address isEqualToString:item]) {
            [context deleteObject:host];
        }
    }
}


#pragma mark -Методы работы с CoreData-
//Контекст
-(NSManagedObjectContext*)takeContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[NSApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

//Получение данных из CoreData
-(NSArray*)dataFromCoreData{
    NSManagedObjectContext *context = [self takeContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HostList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end

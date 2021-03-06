//
//  AddHostViewController.m
//  Network Monitor
//
//  Created by Максим on 06.01.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "AddHostViewController.h"
#import "HostList.h"
#import "Group.h"

@interface AddHostViewController ()

@end

NSDictionary *dict;
@implementation AddHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [_groupChangeMenu addItemWithTitle:@""];
    dict = [self groupNameWithObjectsDictinary];
    [_groupChangeMenu addItemsWithTitles:[dict allKeys]];
}

- (IBAction)saveButton:(NSButton *)sender {
    NSManagedObjectContext *context = [self takeContext];
    HostList *addHost = [NSEntityDescription insertNewObjectForEntityForName:@"HostList" inManagedObjectContext:context];
    if (addHost) {
        addHost.address = self.ipAddressField.stringValue;
        addHost.port = [NSNumber numberWithInteger:[self.portField.stringValue integerValue]];
    }
    
    NSError *saveError = nil;
    
    if (![[_groupChangeMenu titleOfSelectedItem]isEqualToString:@""]) {
        Group *groupObject = [dict objectForKey:[_groupChangeMenu titleOfSelectedItem]];
        [groupObject addHostListObject:addHost];
    }
    
    if (![context save:&saveError]) {
        self.statusLabel.stringValue = @"Ошибка записи в базу!";
        self.statusLabel.textColor = [NSColor redColor];
    }
    else
    {
        self.statusLabel.stringValue = @"Сохранено!";
        self.statusLabel.textColor = [NSColor greenColor];
    }
}

#pragma mark -CoreData Methods-
//Получение групп.
-(NSArray*)dataFromCoreData{
    NSManagedObjectContext *context = [self takeContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Group" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:nil];
}

//Получаем контекст
-(NSManagedObjectContext*)takeContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[NSApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark -Метод для сортировки групп-
-(NSDictionary*)groupNameWithObjectsDictinary{
    NSArray *arr = [self dataFromCoreData];
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    
    for (Group *tmpGroup in arr){
        [myDict setObject:tmpGroup forKey:tmpGroup.name];
    }
    
    return myDict;
}
@end

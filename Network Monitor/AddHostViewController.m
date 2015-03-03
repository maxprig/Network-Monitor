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

@implementation AddHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [_groupChangeMenu addItemWithTitle:@"1234"];
    NSDictionary *dict = [self groupNameWithObjectsDictinary];
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
    
    if (![context save:&saveError]) {
        self.statusLabel.stringValue = @"Ошибка записи в базу!";
        self.statusLabel.textColor = [NSColor redColor];
    }
    else
    {
        self.statusLabel.stringValue = @"Успешно!";
        self.statusLabel.textColor = [NSColor greenColor];
    }
}

#pragma mark -CoreData Methids-
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

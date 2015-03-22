//
//  AddGroupViewController.m
//  Network Monitor
//
//  Created by Максим on 18.02.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "AddGroupViewController.h"
#import "Group.h"

@interface AddGroupViewController ()

@end

@implementation AddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//Кнопка
- (IBAction)saveButton:(NSButton *)sender {
    NSArray *array = [self dataFromCoreData]; //Будем смотреть колличество групп
    
    NSManagedObjectContext *context = [self takeContext];
    Group *new = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:context];
    if (new) {
        new.name = _insertGroupName.stringValue;
        new.groupID = [NSNumber numberWithInteger:[array count]+1];
    }
    
    NSError *saveError = nil;
    
    if (![context save:&saveError]) {
        NSLog(@"Ошибка записи в базу.");
    }
    else
    {
        NSLog(@"Запись прошла успешно");
    }
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

//Получение групп из CoreData
-(NSArray*)dataFromCoreData{
    NSManagedObjectContext *context = [self takeContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Group" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end

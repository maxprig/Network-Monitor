//
//  SettingsVC.m
//  Network Monitor
//
//  Created by Максим on 29.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "SettingsVC.h"
#import "Settings.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Settings *settings = nil;
    
    NSArray *tmp = [self dataFromCoreData];
    for (Settings *object in tmp){
        settings = object;
    }
    
    if (settings) {
        if ([settings.controllInternet isEqualToNumber:@0]) {
            _controllInternet.state = 0;
        }
        else
        {
            _controllInternet.state = 1;
        }
        
        if ([settings.writingLog isEqualToNumber:@0]) {
            _writingLog.state = 0;
            _logPath.enabled = 0;
            _logPath.stringValue = @"";
        }
        else
        {
            _writingLog.state = 1;
            _logPath.enabled = 1;
            _logPath.stringValue = settings.logPath;
        }
    }
    else
    {
        if (_writingLog.state == 0) {
            _logPath.enabled = NO;
        }else if (_writingLog.state == 1){
            _logPath.enabled = YES;
        }
    }
}

#pragma mark -Buttons-
- (IBAction)controllCheckBox:(NSButton *)sender {
}

- (IBAction)writingLogCheckBox:(NSButton *)sender {
    if (_writingLog.state == 0) {
        _logPath.enabled = NO;
    }else if (_writingLog.state == 1){
        _logPath.enabled = YES;
    }
}

- (IBAction)saveButton:(NSButton *)sender {
    [self clearSettingsTable];
    
    NSManagedObjectContext *context = [self takeContext];
    Settings *settings = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:context];
    if (settings) {
        settings.controllInternet = [NSNumber numberWithInteger:_controllInternet.state];
        settings.writingLog = [NSNumber numberWithInteger:_writingLog.state];
        settings.logPath = _logPath.stringValue;
    }
    NSError *saveError = nil;
    
    if (![context save:&saveError]) {
        NSLog(@"Ошибка записи в базу");
    }

}


#pragma mark -CoreData Methods-
//Получаем контекст
-(NSManagedObjectContext*)takeContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[NSApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

//Получение данных из Settings
-(NSArray*)dataFromCoreData{
    NSManagedObjectContext *context = [self takeContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:nil];
}

//Метод очистки таблицы с настройками
-(void)clearSettingsTable{
    NSManagedObjectContext *context = [self takeContext];
    NSArray *settings = [self dataFromCoreData];
    for (NSManagedObject *object in settings){
        [context deleteObject:object];
    }
}

@end

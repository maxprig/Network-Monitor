//
//  AddHostViewController.m
//  Network Monitor
//
//  Created by Максим on 06.01.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "AddHostViewController.h"
#import "HostList.h"

@interface AddHostViewController ()

@end

@implementation AddHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
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


//Получаем контекст
-(NSManagedObjectContext*)takeContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[NSApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
@end

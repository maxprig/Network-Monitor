//
//  ViewController.m
//  Network Monitor
//
//  Created by Максим on 06.01.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "ViewController.h"
#import "HostObject.h"
#import "HostList.h"

@implementation ViewController
@synthesize scan;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)startButton:(NSButton *)sender {
    if (!scan) {
    scan = true;
        
        if([[self dataFromCoreData] count]!=0){
            self.consoleTextField.string = @""; //Почистим консольку
            self.consoleTextField.string = @"Начало сканирования";
            self.statusLabel.stringValue = @"В работе";
            self.statusLabel.textColor = [NSColor greenColor];
            [self doScaning];
        }
        else
        {
                self.consoleTextField.string = @"В базе нет записей";
            scan = false;
            self.statusLabel.stringValue = @"Остановлена";
            self.statusLabel.textColor = [NSColor redColor];
        }
    }
}

- (IBAction)stopButton:(NSButton *)sender {
    if (scan) {
    scan = false;
    self.consoleTextField.string = [NSString stringWithFormat:@"%@ \n Остановка сканирования", self.consoleTextField.string];
        self.statusLabel.stringValue = @"Остановлена";
        self.statusLabel.textColor = [NSColor redColor];
    }
}

-(void)doScaning{
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
      NSArray *hst = [self dataFromCoreData];
      for (HostList *address in hst) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.consoleTextField.string = [NSString stringWithFormat:@"%@ \n Проверка соединения с %@", self.consoleTextField.string, [address valueForKey:@"address"]];
        });
        
        HostObject *tmpObject = [[HostObject alloc]initWithAddress:[address valueForKey:@"address"]];
        [tmpObject doConnection];
        
        if ([tmpObject hostStatus] && scan) {
            dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *msg = [NSString stringWithFormat:@"Хост %@ доступен", [address valueForKey:@"address"]];
            self.consoleTextField.string = [NSString stringWithFormat:@"%@ \n %@", self.consoleTextField.string, msg];
            });
            }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *msg = [NSString stringWithFormat:@"Хост %@ недоступен", [address valueForKey:@"address"]];
            self.consoleTextField.string = [NSString stringWithFormat:@"%@ \n %@", self.consoleTextField.string, msg];
            });
            }
      }
    });
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

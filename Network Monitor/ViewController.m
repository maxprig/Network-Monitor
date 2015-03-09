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
#import "Group.h"

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
      NSArray *hst = [self takeGroupsFromCoreData];
      for(Group *tempGroup in hst){
          for (HostList *address in tempGroup.hostList) {
              NSLog(@"Група: '%@'\n объект: '%@'", tempGroup.name, [address valueForKey:@"address"]);
              dispatch_sync(dispatch_get_main_queue(), ^{
                  self.consoleTextField.string = [NSString stringWithFormat:@"%@ \n Попытка соединения с %@ на порт №%@", self.consoleTextField.string, [address valueForKey:@"address"], [address valueForKey:@"port"]];
              });
              
              HostObject *tmpObject = [[HostObject alloc]initWithAddress:[address valueForKey:@"address"] port:[address valueForKey:@"port"]];
              [tmpObject doConnection];
              
              if ([tmpObject hostStatus] && scan) {
                  dispatch_sync(dispatch_get_main_queue(), ^{
                      NSString *msg = [NSString stringWithFormat:@"Хост %@:%@ доступен", [address valueForKey:@"address"], [address valueForKey:@"port"]];
                      self.consoleTextField.string = [NSString stringWithFormat:@"%@ \n %@", self.consoleTextField.string, msg];
                  });
              }
              else
              {
                  dispatch_sync(dispatch_get_main_queue(), ^{
                      NSString *msg = [NSString stringWithFormat:@"Хост %@:%@ недоступен", [address valueForKey:@"address"], [address valueForKey:@"port"]];
                      self.consoleTextField.string = [NSString stringWithFormat:@"%@ \n %@", self.consoleTextField.string, msg];
                  });
              }
              sleep(2); //Ожидаение две секунды.
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

//Получение групп
-(NSArray*)takeGroupsFromCoreData{
    NSManagedObjectContext *context = [self takeContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Group" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end

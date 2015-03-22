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
    [self startProgress];
    
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)startProgress{
    if (!scan) {
        scan = true;
        if([[self dataFromCoreData] count]!=0){
            self.statusLabel.stringValue = @"В работе";
            self.statusLabel.textColor = [NSColor greenColor];
            [self doScaning];
        }
        else
        {
            scan = false;
            self.statusLabel.stringValue = @"Остановлена";
            self.statusLabel.textColor = [NSColor redColor];
        }
    }
}

- (IBAction)stopButton:(NSButton *)sender {
    if (scan) {
    scan = false;
        self.statusLabel.stringValue = @"Остановлена";
        self.statusLabel.textColor = [NSColor redColor];
    }
}


//Свойство hostStatus типа BOOL говорит нам о доступности хоста.
-(void)doScaning{
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
      NSMutableArray *arrayWinthHostsDictinary = [NSMutableArray new];
      
      //Забъем данные из CoreData в словари, а потом в массив.
      dispatch_sync(dispatch_get_global_queue(0, 0), ^{
          NSArray *hst = [self takeGroupsFromCoreData];
          for(Group *tempGroup in hst){
              for (HostList *address in tempGroup.hostList) {
                  NSLog(@"Група: '%@'\n объект: '%@'", tempGroup.name, [address valueForKey:@"address"]);
                  
                  NSMutableDictionary *dict = [NSMutableDictionary new];
                  [dict setObject:[address valueForKey:@"address"] forKey:@"Address"]; //Адрес
                  [dict setObject:[address valueForKey:@"port"] forKey:@"Port"]; //Порт
                  [dict setObject:[tempGroup valueForKey:@"name"] forKey:@"GroupName"]; //Имя группы, к которой принадлежит хост.
                  [dict setObject:[tempGroup valueForKey:@"groupID"] forKey:@"GroupID"]; //ID группы.
                  [dict setObject:@"Offline" forKey:@"Online"];
                
                 [arrayWinthHostsDictinary addObject:dict];    //Добавляем словарик в массив.
              }
          }
      });
      
      //Проверяем хосты на доступность и заливаем их в массив.
      NSMutableArray *onlineHostsFromArraWithDictinary = [NSMutableArray new];
      
      for (HostObject *host in arrayWinthHostsDictinary){
          HostObject *object = [[HostObject alloc]initWithAddress:[host valueForKey:@"Address"] port:[host valueForKey:@"Port"]];
          _console.stringValue = [NSString stringWithFormat:@"Попытка соединения с %@", [host valueForKey:@"Address"]];
          [object doConnection];
          if ([object hostStatus]) {
              _console.stringValue = [NSString stringWithFormat:@"Получен ответ от %@. \n Хост доступен", [host valueForKey:@"Address"]];
          }
          else
          {
              _console.stringValue = [NSString stringWithFormat:@"Нет ответа от %@. \n Хост недоступен", [host valueForKey:@"Address"]];
              sleep(3);
          }
          [onlineHostsFromArraWithDictinary addObject:host];
      }
      
      //Передаем все эти словарики в массив синглтона.
      
    });
    
    
    }
                

#pragma mark -PlotMethods-
#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    return [NSDecimalNumber zero];
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

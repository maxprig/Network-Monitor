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
      while (scan) {
          _console.stringValue = @"Начало сканирования.";
          sleep(3);
          NSArray *myHosts = [self dataFromCoreData]; //Получаем все хосты.
          
          NSMutableArray *hostsForScan = [NSMutableArray new]; //Будем сюда забивать полную информацию о хостах.
          
          
          //Массивы в которых будут хосты, которые в сети и не в сети.
          NSMutableArray *online = [NSMutableArray new];
          NSMutableArray *offline = [NSMutableArray new];
          
          //=============================================================================================================
          //Соберем информацию о хостах для сканирования
          for (HostList *hst in myHosts){
              //Всю информацию о хосте будем забивать в словарики.
              NSMutableDictionary *aboutHost = [NSMutableDictionary new];
              
              [aboutHost setObject:hst.address forKey:@"Address"]; //Адрес хоста.
              [aboutHost setObject:hst.port forKey:@"Port"]; //Номер порта.
              
              //Теперь надо проверит, есть ли у хоста группа.
              if ([hst.groups count]) {
                  //Если есть группы, то добавляем ее название в словарь.
                  for (Group *group in hst.groups){
                      [aboutHost setObject:group.name forKey:@"GroupName"];
                  }
              }
              else {
                  //Если нет группы, то просто напишем, что без группы.
                  [aboutHost setObject:@"Без группы" forKey:@"GroupName"];
              }
              
              //Теперь просто добавим этот словарик с информацией о хосте в массив.
              [hostsForScan addObject:aboutHost];
          }
          //=============================================================================================================
          //Теперь, когда собрана вся информация, можно приступать к сканированию.
          
          for (NSDictionary *hostInfo in hostsForScan){
              HostObject *host = [[HostObject alloc]initWithAddress:[hostInfo objectForKey:@"Address"] port:[hostInfo objectForKey:@"Port"]];
              _console.stringValue = [NSString stringWithFormat:@" Попытка соединения с %@ из группы '%@'. Порт №%@.", [hostInfo objectForKey:@"Address"], [hostInfo objectForKey:@"GroupName"], [hostInfo objectForKey:@"Port"]];
              sleep(1);
              [host doConnection]; //Пытаемся соединиться.
              
              //Проверяем результат.
              if ([host hostStatus]) {
                  _console.stringValue = [NSString stringWithFormat:@" Получен ответ от %@ из группы '%@'. Порт №%@ \n Хост доступен. ", [hostInfo objectForKey:@"Address"], [hostInfo objectForKey:@"GroupName"], [hostInfo objectForKey:@"Port"]];
                  [online addObject:host];
                  sleep(3);
              }
              else
              {
                  _console.stringValue = [NSString stringWithFormat:@" Нет ответа от %@ из группы '%@'. Порт №%@ \n Хост или сервис недоступен.", [hostInfo objectForKey:@"Address"], [hostInfo objectForKey:@"GroupName"], [hostInfo objectForKey:@"Port"]];
                  [offline addObject:host];
                  sleep(3);
              }
              
          }
          
          NSLog(@"Online - %lu \n Offline - %lu", (unsigned long)[online count], (unsigned long)[offline count]);
          _console.stringValue = [NSString stringWithFormat:@" В сети - %lu хостов. \n Не в сети - %lu хостов. \n Ожидание.", (unsigned long)[online count], (unsigned long)[offline count]];
          sleep(60);
      }
      
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

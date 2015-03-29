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
#import "OnlineList.h"
#import "CustomCell.h"

NSMutableArray *hosts;
@implementation ViewController

@synthesize scan;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.delegate = self;
    tableView.dataSource = self;
    // Do any additional setup after loading the view.
    [self startProgress];
    hosts = [NSMutableArray new];
    
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)startProgress{
    if (!scan) {
        scan = true;
        if([[self dataFromCoreData] count]!=0){
            [self doScaning];
        }
        else
        {
            scan = false;
        }
    }
}

- (IBAction)stopButton:(NSButton *)sender {
    if (scan) {
    scan = false;
        _console.stringValue = @"Мониторинг остановлен.";
    }
}


//Свойство hostStatus типа BOOL говорит нам о доступности хоста.
-(void)doScaning{
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
      while (scan) {
          [hosts removeAllObjects];
          
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
                      [aboutHost setObject:group.groupID forKey:@"GroupID"];
                  }
              }
              else {
                  //Если нет группы, то просто напишем, что без группы.
                  [aboutHost setObject:@"Без группы" forKey:@"GroupName"];
                  [aboutHost setObject:@"0" forKey:@"GroupID"];
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
                  
                  NSDictionary *dict = @{
                                         @"Address": [hostInfo objectForKey:@"Address"],
                                         @"Group" : [hostInfo objectForKey:@"GroupName"],
                                         @"Port" :  [hostInfo objectForKey:@"Port"],
                                         @"Status": @"Online"
                                         };
                  [hosts addObject:dict];
                  sleep(3);
              }
              else
              {
                  _console.stringValue = [NSString stringWithFormat:@" Нет ответа от %@ из группы '%@'. Порт №%@ \n Хост или сервис недоступен.", [hostInfo objectForKey:@"Address"], [hostInfo objectForKey:@"GroupName"], [hostInfo objectForKey:@"Port"]];
                  [offline addObject:host];
                  
                  NSDictionary *dict = @{
                                         @"Address": [hostInfo objectForKey:@"Address"],
                                         @"Group" : [hostInfo objectForKey:@"GroupName"],
                                         @"Port" :  [hostInfo objectForKey:@"Port"],
                                         @"Status": @"Offline"
                                         };
                  [hosts addObject:dict];
                  sleep(3);
              }
              
          }
          
          //=============================================================================================================
          //Производим запись в табличку OnlineList информации о хостах.
          
          NSLog(@"Online - %lu \n Offline - %lu", (unsigned long)[online count], (unsigned long)[offline count]);
          _console.stringValue = [NSString stringWithFormat:@" В сети - %lu хостов. \n Не в сети - %lu хостов. \n Ожидание.", (unsigned long)[online count], (unsigned long)[offline count]];
          [tableView reloadData];
          [self monitoringGroups:hosts];
          sleep(60);
      }
      
  });
    
    
    }
                

#pragma mark -Monitoring Method-
-(void)monitoringGroups:(NSArray*)hosts{
    NSArray *groups = [self takeGroupsFromCoreData]; //Получаем группы
    for (Group *group in groups){
        NSString *nameGroup = group.name;
        NSInteger groupCounter = [group.hostList count];
        
        NSMutableArray *online = [NSMutableArray new];
        NSMutableArray *offline = [NSMutableArray new];
        
        for (NSDictionary *hostsDict in hosts){
            NSLog(@"%@", hostsDict);
            if ([[hostsDict objectForKey:@"Group"] isEqualToString:nameGroup]) {
                NSLog(@"%@", [hostsDict objectForKey:@"Status"] );
                if ([[hostsDict objectForKey:@"Status"] isEqualToString:@"Online"]) {
                    [online addObject:hostsDict];
                }
                else
                {
                    [offline addObject:hostsDict];
                }
            }
        }
            if ([offline count] == groupCounter) {
                NSDictionary *group = [offline lastObject];
                
                
                NSString *message = [NSString stringWithFormat:@"Потеряно соединение с группой '%@'.", [group objectForKey:@"Group"]];
                
                NSAlert *alert = [[NSAlert alloc] init];
                [alert addButtonWithTitle:@"OK"];
                [alert setMessageText:message];
                [alert setAlertStyle:NSInformationalAlertStyle];
              //  [alert setAlertStyle:NSCriticalAlertStyle];
                
                [alert runModal];
               
                
            }
                
        }
    }
    


#pragma mark -TableView DataSource and Delegate-
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return [hosts count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
        NSString *ident = @"hostCell";
    CustomCell *cell = [tableView makeViewWithIdentifier:ident owner:self];
    cell.rowSizeStyle = NSTableViewRowSizeStyleCustom;
    NSDictionary *dict = [hosts objectAtIndex:row];
    
    if (cell) {
        cell.ipAddressCell.stringValue = [dict objectForKey:@"Address"];
        cell.groupCell.stringValue = [dict objectForKey:@"Group"];
        if ([[dict objectForKey:@"Status"] isEqualToString:@"Online"]) {
            [cell.cellImage setImage:[NSImage imageNamed:@"online.gif"]];
        }else{
            [cell.cellImage setImage:[NSImage imageNamed:@"offline.png"]];
        }
    }
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 60.0;
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

////Метод очистки Onlinelist
//-(void)clearOnlineList{
//    NSManagedObjectContext *context = [self takeContext];
//    if (![[self onlineListFromCoreData]count]) {
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init]; //Определяем запрос
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"OnlineList" inManagedObjectContext:context];
//        [fetchRequest setEntity:entity];
//        NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
//        if ([array count]!=0) {
//            for (NSManagedObject *object in array) {
//                [context deleteObject:object];
//            }
//        }
//    }
//}
//
////Метод записи в OnlineList
//-(void)saveInfoAboutHostIntoDataBase:(NSDictionary*)object online:(BOOL)online{
//    NSManagedObjectContext *context = [self takeContext];
//    OnlineList *addIntoList = [NSEntityDescription insertNewObjectForEntityForName:@"OnlineList" inManagedObjectContext:context];
//    if (addIntoList) {
//        addIntoList.address = [object valueForKey:@"Address"];
//        addIntoList.port = [object valueForKey:@"Port"];
//        addIntoList.groupName = [object valueForKey:@"GroupName"];
//        addIntoList.groupId = [object valueForKey:@"GroupID"];
//        
//        if (online) {
//            addIntoList.online = @1;
//        }
//        else{
//            addIntoList.online = @0;
//        }
//    }
//    
//}

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

//Получение записей из OnlineList
-(NSArray*)onlineListFromCoreData{
    NSManagedObjectContext *context = [self takeContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OnlineList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end

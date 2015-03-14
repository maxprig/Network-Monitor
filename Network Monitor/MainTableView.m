//
//  MainTableView.m
//  Network Monitor
//
//  Created by Максим on 09.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "MainTableView.h"
#import "CustomCell.h"
#import "Group.h"

NSMutableArray *hosts;
@implementation MainTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get a new ViewCell
    CustomCell *cellView = [tableView makeViewWithIdentifier:@"Cell" owner:self];
    cellView.rowSizeStyle = NSTableViewRowSizeStyleCustom;
    
    
    if (cellView) {
        cellView.ipAddressCell.stringValue = [NSString stringWithFormat:@"%@", [[hosts objectAtIndex:row] valueForKey:@"address"]];
        cellView.groupCell.stringValue = @"";
        [cellView.cellImage setImage:[NSImage imageNamed:@"girl.gif"]];
    }
    
    
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if (!hosts) {
        hosts = [[NSMutableArray alloc]initWithArray:[self dataFromCoreData]];
    }
    return [[self dataFromCoreData]count];
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView{
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 50.0;
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

//Получение данных из CoreData
-(NSArray*)dataFromCoreData{
    NSManagedObjectContext *context = [self takeContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HostList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end

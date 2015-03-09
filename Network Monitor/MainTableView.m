//
//  MainTableView.m
//  Network Monitor
//
//  Created by Максим on 09.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "MainTableView.h"
#import "CustomCell.h"

@implementation MainTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
    
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get a new ViewCell
    CustomCell *cellView = [tableView makeViewWithIdentifier:@"Cell" owner:self];
    //cellView.rowSizeStyle = NSTableViewRowSizeStyleCustom;
    //cellView.frame = CGRectMake(0, 0, 660, 70);
    
    if (cellView) {
        cellView.ipAddressCell.stringValue = @"Addres :3";
        cellView.groupCell.stringValue = @"Group :3";
        [cellView.cellImage setImage:[NSImage imageNamed:@"girl.gif"]];
    }
    
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 1;
}
@end

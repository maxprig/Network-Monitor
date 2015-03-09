//
//  CustomCell.h
//  Network Monitor
//
//  Created by Максим on 09.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomCell : NSTableCellView
@property (weak) IBOutlet NSTextField *ipAddressCell;
@property (weak) IBOutlet NSImageView *cellImage;
@property (weak) IBOutlet NSTextField *groupCell;

@end

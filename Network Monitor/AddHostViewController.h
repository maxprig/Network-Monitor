//
//  AddHostViewController.h
//  Network Monitor
//
//  Created by Максим on 06.01.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AddHostViewController : NSViewController

@property (weak) IBOutlet NSTextField *ipAddressField;
@property (weak) IBOutlet NSTextField *portField;

@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSComboBox *groupChange;

- (IBAction)saveButton:(NSButton *)sender;

@end

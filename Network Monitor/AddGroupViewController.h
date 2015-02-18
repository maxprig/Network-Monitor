//
//  AddGroupViewController.h
//  Network Monitor
//
//  Created by Максим on 18.02.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AddGroupViewController : NSViewController
@property (weak) IBOutlet NSTextField *insertGroupName;
- (IBAction)saveButton:(NSButton *)sender;

@end

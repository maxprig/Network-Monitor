//
//  SettingsVC.h
//  Network Monitor
//
//  Created by Максим on 29.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingsVC : NSViewController
@property (weak) IBOutlet NSButton *controllInternet;
@property (weak) IBOutlet NSButton *writingLog;
@property (weak) IBOutlet NSTextField *logPath;

- (IBAction)controllCheckBox:(NSButton *)sender;
- (IBAction)writingLogCheckBox:(NSButton *)sender;

- (IBAction)saveButton:(NSButton *)sender;

@end

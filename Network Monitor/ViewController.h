//
//  ViewController.h
//  Network Monitor
//
//  Created by Максим on 06.01.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainTableView.h"

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (assign) BOOL scan;

@property (unsafe_unretained) IBOutlet NSTextView *consoleTextField;

@property (weak) IBOutlet MainTableView *myTableView;

@property (weak) IBOutlet NSTextField *statusLabel;

- (IBAction)startButton:(NSButton *)sender;
- (IBAction)stopButton:(NSButton *)sender;

@end


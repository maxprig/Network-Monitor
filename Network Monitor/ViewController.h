//
//  ViewController.h
//  Network Monitor
//
//  Created by Максим on 06.01.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainTableView.h"
#import <CPTPlot.h>

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, CPTPlotDataSource>

@property (assign) BOOL scan;

@property (unsafe_unretained) IBOutlet NSTextView *consoleTextField;

@property (weak) IBOutlet NSTextField *console;

@property (weak) IBOutlet MainTableView *myTableView;

@property (weak) IBOutlet NSTextField *statusLabel;

- (IBAction)startButton:(NSButton *)sender;
- (IBAction)stopButton:(NSButton *)sender;

@property (weak) IBOutlet NSView *graphView;

@end


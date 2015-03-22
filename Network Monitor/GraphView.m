//
//  GraphView.m
//  Network Monitor
//
//  Created by Максим on 21.03.15.
//  Copyright (c) 2015 Prigozhenkov Maxim. All rights reserved.
//

#import "GraphView.h"
#define kGraphHeight 300
#define kDefaultGraphWidth 900
#define kOffsetX 0
#define kStepX 28
#define kGraphBottom 300
#define kGraphTop 10
#define kStepY 60
#define kOffsetY 0
#define kBarTop 10
#define kBarWidth 40


@implementation GraphView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    // Получим context
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    [self drawLine:context];
    //CGContextSetFillColorWithColor(context, [[NSColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[NSColor lightGrayColor] CGColor]);
    
    // How many lines?
    int howMany = (kDefaultGraphWidth - kOffsetX) / kStepX;
    
    // Here the lines go
    for (int i = 0; i < howMany; i++)
    {
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
    }
    
    int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kStepY);
    }
    

    
    CGContextStrokePath(context);
}

-(void)drawLine:(CGContextRef)context{
    CGContextSetStrokeColorWithColor(context, [[NSColor orangeColor] CGColor]);
    CGContextSetLineWidth(context, 3.0);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, 28.0, 240.0);
    CGContextStrokePath(context);
}

@end

//
//  SGDialogView.m
//  SoraGal
//
//  Created by conans on 1/15/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGDialogView.h"

@implementation SGDialogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDialogAlpha:(CGFloat)dialogAlpha{
    if(dialogAlpha != _dialogAlpha){
        _dialogAlpha = dialogAlpha;
        [self setNeedsDisplay];
    }
}

- (void)drawDialogBox:(CGContextRef)context{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.114 green: 0.706 blue: 1 alpha: self.dialogAlpha];
    UIColor* color3 = [UIColor colorWithRed: 0.8 green: 0.933 blue: 1 alpha: self.dialogAlpha];
    UIColor* color4 = [UIColor colorWithRed: 0.114 green: 0.705 blue: 1 alpha: self.dialogAlpha];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)color3.CGColor,
                               (id)[UIColor colorWithRed: 0.457 green: 0.82 blue: 1 alpha: self.dialogAlpha].CGColor,
                               (id)color2.CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.51, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(23.5, 5.5, 521, 94) cornerRadius: 5];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(284, 5.5), CGPointMake(284, 99.5), 0);
    CGContextRestoreGState(context);
    [color4 setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawDialogBox:UIGraphicsGetCurrentContext()];
}

@end

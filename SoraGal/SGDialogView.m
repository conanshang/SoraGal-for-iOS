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

- (void)setDialogName:(NSString *)dialogName{
    if(dialogName != _dialogName){
        _dialogName = dialogName;
        //[self setNeedsDisplay];
    }
}

- (void)setDialogText:(NSString *)dialogText{
    if(dialogText != _dialogText){
        _dialogText = dialogText;
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

    //// Text 2 Drawing
    CGRect text2Rect = CGRectMake(30, 4, 505, 25);
    NSMutableParagraphStyle* text2Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [text2Style setAlignment: NSTextAlignmentLeft];
    
    NSDictionary* text2FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 18], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: text2Style};
    
    [@"悠：" drawInRect: CGRectInset(text2Rect, 0, 3) withAttributes: text2FontAttributes];
    
    //// Abstracted Attributes
    NSString* textContent = @"我本以为,自由我才会有这种稀奇古怪的想法吧,可没想到的是前几天看的推理小说中,里面的犯人也和我同样的幻想着蔚蓝的天空让人觉得异常清澈.不同城市的天空,纯粹的蓝等间隔的电线杆从眼前一个一个的飞过让我想起了小时候";
    //// Text Drawing
    CGRect textRect = CGRectMake(30, 29, 511, 60);
    NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [textStyle setAlignment: NSTextAlignmentLeft];
    
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 15], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: textStyle};
    
    [textContent drawInRect:CGRectInset(textRect, 0, 3) withAttributes: textFontAttributes];
    
    
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

















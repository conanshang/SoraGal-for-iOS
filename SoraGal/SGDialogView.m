//
//  SGDialogView.m
//  SoraGal
//
//  Created by conans on 1/15/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGDialogView.h"

@interface SGDialogView()

//If display the name box.
@property BOOL ifShowDialogNameBox;

//For display text one by one.
@property NSUInteger currentPosition;
@property (nonatomic, strong) NSString *currentText;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SGDialogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.ifShowDialogNameBox = NO;
    }
    return self;
}

- (void)setDialogAlpha:(CGFloat)dialogAlpha{
    if(dialogAlpha != _dialogAlpha){
        _dialogAlpha = dialogAlpha;
        [self setNeedsDisplay];
    }
}

- (void)setDialogTextDisplaySpeedInSecond:(float)dialogTextDisplaySpeedInSecond{
    if(dialogTextDisplaySpeedInSecond != _dialogTextDisplaySpeedInSecond){
        _dialogTextDisplaySpeedInSecond = dialogTextDisplaySpeedInSecond;
    }
}

- (void)setDialogName:(NSString *)dialogName{
    if([dialogName isEqualToString:@""]){
        self.ifShowDialogNameBox = NO;
    }
    else{
        if(dialogName != _dialogName){
            _dialogName = dialogName;
            
            self.ifShowDialogNameBox = YES;
            //[self setNeedsDisplay];
        }
    }
}

- (void)setDialogText:(NSString *)dialogText{
    if(dialogText != _dialogText){
        _dialogText = dialogText;
        
        if(self.dialogTextDisplaySpeedInSecond == 0){
            self.currentText = self.dialogText;
            [self setNeedsDisplay];
        }
        else{
            //For display text one by one.
            [self.timer invalidate];
            
            self.currentText = [NSString new];
            self.currentPosition = 0;
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.dialogTextDisplaySpeedInSecond target:self selector:@selector(typingDialog) userInfo:nil repeats:YES];
        }
    }
}

- (void)typingDialog{
    self.currentText = [self.dialogText substringToIndex:self.currentPosition];
    
    [self setNeedsDisplay];
    
    self.currentPosition++;
    
    if(self.currentPosition >= [self.dialogText length]){
        [self.timer invalidate];
    }
}

- (CGFloat)calculateDialogNameBoxLengthUseFontsInfomation:(NSDictionary *)fonts{
    CGSize nameSize = [self.dialogName sizeWithAttributes:fonts];
    
    return nameSize.width;
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
    
    //// Dialog Box Drawing
    UIBezierPath* dialogBoxPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(9, 33, 550, 93) cornerRadius: 5];
    CGContextSaveGState(context);
    [dialogBoxPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(284, 33), CGPointMake(284, 126), 0);
    CGContextRestoreGState(context);
    [color4 setStroke];
    dialogBoxPath.lineWidth = 1;
    [dialogBoxPath stroke];
    
    //// Dialog Text Drawing
    CGRect dialogTextRect = CGRectMake(19, 43, 530, 83);
    NSMutableParagraphStyle* dialogTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [dialogTextStyle setAlignment: NSTextAlignmentLeft];
    
    NSDictionary* dialogTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 15], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: dialogTextStyle};
    
    [self.currentText drawInRect: dialogTextRect withAttributes: dialogTextFontAttributes];
    
    //// Name Box Drawing & Name Text Drawing
    if(self.ifShowDialogNameBox){
        //Set Name Text fonts.
        NSMutableParagraphStyle* nameTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        NSDictionary* nameTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 18], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: nameTextStyle};
        
        //Get the display length of name text for the fonts settings.
        CGFloat nameTextLengthInPoint = [self calculateDialogNameBoxLengthUseFontsInfomation:nameTextFontAttributes];
        
        //Name Box Drawing.
            //Set the box length dynamiclly from character name's length.
        UIBezierPath* nameBoxPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(9, 3, nameTextLengthInPoint + 10, 27) cornerRadius: 5]; //+10 means box is larger.
        CGContextSaveGState(context);
        [nameBoxPath addClip];
        CGContextDrawLinearGradient(context, gradient, CGPointMake(84, 3), CGPointMake(84, 30), 0);
        CGContextRestoreGState(context);
        [color4 setStroke];
        nameBoxPath.lineWidth = 1;
        [nameBoxPath stroke];
        
        //Draw the name text. If draw the before the name box, name box wii overdraw the text.
            //Set the box length dynamiclly from character name's length.
        CGRect nameTextRect = CGRectMake(9 + 5, 5, nameTextLengthInPoint, 23); //+5 means add half of the larger amount of the box, which is +10 above.
        [nameTextStyle setAlignment: NSTextAlignmentRight];
        [self.dialogName drawInRect: CGRectInset(nameTextRect, 0, 1.5) withAttributes: nameTextFontAttributes];
    }

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

















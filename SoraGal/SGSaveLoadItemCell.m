//
//  SGSaveLoadItemCell.m
//  SoraGal
//
//  Created by conans on 2/23/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGSaveLoadItemCell.h"

@implementation SGSaveLoadItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Initial the Save Data Image.
        self.saveDataScreenShotImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 156, 88)];
        [self addSubview:self.saveDataScreenShotImage];
        
        //Temp set the creation date, need set it in Collection Controller.
        self.saveDateCreationDateString = @"02/23/2014";
        
        //Clear the background color.
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawCellContent:(CGContextRef)context{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 1 green: 0.335 blue: 0.992 alpha: 1];
    UIColor* color3 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* gradientColor = [UIColor colorWithRed: 1 green: 0.738 blue: 0.974 alpha: 1];
    UIColor* color4 = [UIColor colorWithRed: 1 green: 0.571 blue: 1 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)gradientColor.CGColor,
                               (id)[UIColor colorWithRed: 1 green: 0.536 blue: 0.983 alpha: 1].CGColor,
                               (id)color.CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.45, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Abstracted Attributes
    NSString* createDateContent = @"Creation Date";
    NSString* dateContent = self.saveDateCreationDateString;
    
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 279, 108) cornerRadius: 8];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(139.5, -0), CGPointMake(139.5, 108), 0);
    CGContextRestoreGState(context);
    [color4 setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    
    //// Create Date Drawing
    CGRect createDateRect = CGRectMake(185, 10, 70, 12);
    NSMutableParagraphStyle* createDateStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [createDateStyle setAlignment: NSTextAlignmentCenter];
    
    NSDictionary* createDateFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 11], NSForegroundColorAttributeName: color3, NSParagraphStyleAttributeName: createDateStyle};
    
    [createDateContent drawInRect: createDateRect withAttributes: createDateFontAttributes];
    
    
    //// Date Drawing
    CGRect dateRect = CGRectMake(185, 27, 70, 12.5);
    NSMutableParagraphStyle* dateStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [dateStyle setAlignment: NSTextAlignmentCenter];
    
    NSDictionary* dateFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 11], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: dateStyle};
    
    [dateContent drawInRect: dateRect withAttributes: dateFontAttributes];
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    
    //Set the round corner of screen shot image.
    self.saveDataScreenShotImage.layer.cornerRadius = 5;
    self.saveDataScreenShotImage.layer.masksToBounds = YES;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawCellContent:UIGraphicsGetCurrentContext()];
}

@end

















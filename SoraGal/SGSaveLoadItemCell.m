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
        self.saveDataScreenShotImage = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 9.5, 156, 88)];
        [self addSubview:self.saveDataScreenShotImage];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(188, 48, 76, 15)];
        self.dateLabel.font = [UIFont fontWithName: @"Helvetica" size: 11];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dateLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(188, 63, 76, 15)];
        self.timeLabel.font = [UIFont fontWithName: @"Helvetica" size: 11];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeLabel];
        
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
    NSString* createTimeContent = @"Create Time";
    
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, 279, 108) cornerRadius: 8];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(139.5, -0), CGPointMake(139.5, 108), 0);
    CGContextRestoreGState(context);
    [color4 setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    
    //// Create Time Drawing`
    CGRect createTimeRect = CGRectMake(188, 31, 76, 17);
    NSMutableParagraphStyle* createTimeStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [createTimeStyle setAlignment: NSTextAlignmentCenter];
    
    NSDictionary* createTimeFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 13], NSForegroundColorAttributeName: color3, NSParagraphStyleAttributeName: createTimeStyle};
    
    [createTimeContent drawInRect: createTimeRect withAttributes: createTimeFontAttributes];
    
    
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

















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
        // Initialization code
    }
    return self;
}

- (void)drawCellContent:(CGContextRef)context{
    //// General Declarations
    //CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //// Color Declarations
    UIColor* color3 = [UIColor colorWithRed: 1 green: 0.343 blue: 0.562 alpha: 1];
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0.5, -0.5, 279, 108)];
    [color3 setFill];
    [roundedRectanglePath fill];
    
    
     
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawCellContent:UIGraphicsGetCurrentContext()];
}

@end

















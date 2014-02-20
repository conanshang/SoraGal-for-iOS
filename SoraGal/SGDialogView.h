//
//  SGDialogView.h
//  SoraGal
//
//  Created by conans on 1/15/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGDialogView : UIView

//For displaying use.
@property (nonatomic, strong) NSString *dialogName;
@property (nonatomic, strong) NSString *dialogText;

//For settings use.
@property (nonatomic, readwrite) CGFloat dialogAlpha;
@property (nonatomic, readwrite) float dialogTextDisplaySpeedInSecond;

@end

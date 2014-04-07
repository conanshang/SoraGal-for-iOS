//
//  TCustomAlertView.m
//  Test
//
//  Created by conans on 4/5/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "TCustomAlertView.h"

@interface TCustomAlertView()

@property (nonatomic, weak) UIView *theSuperView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property CGFloat totalWidthForAlertView;
@property CGFloat totalHeightForAlertView;
@property CGFloat animationDuration;

@end

@implementation TCustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        self.animationDuration = 0.4f;
    }
    return self;
}

- (id)initWithSuperView:(UIView *)superView{
    //Get the current screen bounds.
    CGRect frame = [[UIScreen mainScreen] bounds];
    //Check the orientation, and sdjust the frame.
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(UIInterfaceOrientationIsLandscape(orientation)){
        float temp = frame.size.height;
        frame.size.height = frame.size.width;
        frame.size.width = temp;
    }
    
    //Create the view.
    self = [self initWithFrame:frame];
    if(self){
        self.theSuperView = superView;
        //self.delegate = self.theSuperView;
    }
    return self;
}

- (id)initWithSuperView:(UIView *)superView title:(NSString *)title andDetail:(NSString *)detail{
    //Create the view.
    self = [self initWithSuperView:superView];
    if(self){
        self.tittleText = title;
        self.detailText = detail;
    }
    return self;
}

- (id)initWithSuperView:(UIView *)superView title:(NSString *)title detail:(NSString *)detail confirmText:(NSString *)confirmText andCancelText:(NSString *)cancelText{
    //Create the view.
    self = [self initWithSuperView:superView title:title andDetail:detail];
    if(self){
        self.confirmText = confirmText;
        self.cancelText = cancelText;
    }
    return self;
}

- (void)show{
    //Set the data.
    [self setupInitialData];
    
    //Show the background view in color.
    [self setupTheBackground];
    
    //Show the alertView.
    [self setupTheAlertView];
    
    //Add to super view.
    [self.theSuperView addSubview:self];
    
    //Animation
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundView.alpha = 0.6f;
    } completion:^(BOOL finished) {

    }];
}

- (void)dismiss{
    [self removeFromSuperview];
}

- (void)dismissFromSender:(NSString *)sender{
    //Add dynamic effects.
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.alertView]];
    gravityBehavior.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehavior];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.alertView]];
    [itemBehavior addAngularVelocity:-M_PI_2 forItem:self.alertView];
    [self.animator addBehavior:itemBehavior];
    
    [self.animator addBehavior:gravityBehavior];
    [self.animator addBehavior:itemBehavior];
    
    //Animation
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self dismiss];
        
        if([sender isEqualToString:@"confirm"]){
            if([_delegate respondsToSelector:@selector(didAlertViewDisappeared)]){
                [_delegate didAlertViewDisappeared];
            }
        }
    }];
}

- (void)setupInitialData{
    if(!self.tittleText){
        self.tittleText = @"No tittle";
    }
    
    if(!self.detailText){
        self.detailText = @"No detail";
    }
    
    if(!self.confirmText){
        self.confirmText = @"Confirm";
    }
    
    if(!self.cancelText){
        self.cancelText = @"Cancel";
    }
    
    if(!self.alertViewBorderRadius){
        self.alertViewBorderRadius = 10;
    }
}

- (void)setupTheBackground{
    self.backgroundView = [[UIView alloc] initWithFrame:[self bounds]];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1];
    self.backgroundView.alpha = 0;
    
    [self addSubview:self.backgroundView];
}

- (void)setupTheAlertView{
    //Reuseable variables.
    CGColorRef borderColor = [[UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1] CGColor];
    UIColor *titleBarColor = [UIColor colorWithRed:234/255.0 green:52/255.0 blue:255/255.0 alpha:1];
    UIColor *alertViewBackgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    
    
    //Create the alert view box.
    CGRect bounds = [self bounds];
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width * 0.475, bounds.size.height * 0.39)];
    self.totalWidthForAlertView = self.alertView.frame.size.width;
    self.totalHeightForAlertView = self.alertView.frame.size.height;
    
    self.alertView.center = self.center;
    self.alertView.backgroundColor = alertViewBackgroundColor;
    self.alertView.layer.cornerRadius = self.alertViewBorderRadius;
    self.alertView.layer.borderWidth = 0.3;
    self.alertView.layer.borderColor = borderColor;
    
    
    //Create the pink tittle
    UIView *tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.totalWidthForAlertView, 30)];
    tittleView.backgroundColor = titleBarColor;
    tittleView.layer.cornerRadius = 10;
    [self.alertView addSubview:tittleView];
    
    UIView *tittleNoLowerRadiusFill = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.totalWidthForAlertView, 10)];
    tittleNoLowerRadiusFill.backgroundColor = titleBarColor;
    [self.alertView addSubview:tittleNoLowerRadiusFill];
    
    UILabel *tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.totalWidthForAlertView - 20, tittleView.frame.size.height)];
    tittleLabel.center = tittleView.center;
    tittleLabel.text = self.tittleText;
    tittleLabel.textAlignment = NSTextAlignmentCenter;
    tittleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    tittleLabel.textColor = alertViewBackgroundColor;
    [self.alertView addSubview:tittleLabel];
    
    
    //Create the detail box.
    self.detailView = [[UIView alloc] initWithFrame:CGRectMake(0, tittleView.frame.size.height, self.totalWidthForAlertView, self.totalHeightForAlertView - tittleView.frame.size.height - 25)];
    
        // Add a bottomBorder.
    [self addABorderTo:self.detailView on:@"bottom" useColor:borderColor];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.detailView.frame.size.width - 20, self.detailView.frame.size.height - 10)];
    detailLabel.numberOfLines = 5;
    detailLabel.text = self.detailText;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    detailLabel.textColor = [UIColor blackColor];
    [self.detailView addSubview:detailLabel];
    [self.alertView addSubview:self.detailView];
    
    
    //Create the buttons.
        //The height of some elements.
    CGFloat buttonBarTotalHeight = self.totalHeightForAlertView - tittleView.frame.size.height - self.detailView.frame.size.height;
    CGFloat buttonPositionY = self.detailView.frame.origin.y + self.detailView.frame.size.height;
    CGFloat buttonWidth = self.totalWidthForAlertView / 2;
    CGFloat buttonHeight = self.totalHeightForAlertView - buttonBarTotalHeight / 2;
    CGFloat buttonCenterBase = self.totalWidthForAlertView / 4.0;
    
        //Cancel button.
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0,buttonPositionY, buttonWidth, buttonBarTotalHeight);
    cancelButton.center = CGPointMake(buttonCenterBase, buttonHeight);
    [cancelButton setTitle:self.cancelText forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
    if(self.cancelColor){
        [cancelButton setTitleColor:self.cancelColor forState:UIControlStateNormal];
    }
    [self.alertView addSubview:cancelButton];
    
        //Confirm button.
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmButton.frame = CGRectMake(0,buttonPositionY, buttonWidth, buttonBarTotalHeight);
    confirmButton.center = CGPointMake(buttonCenterBase * 3, buttonHeight);
    [confirmButton setTitle:self.confirmText forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:12];
    if(self.confirmColor){
        [confirmButton setTitleColor:self.confirmColor forState:UIControlStateNormal];
    }
    else{
        [confirmButton setTitleColor:titleBarColor forState:UIControlStateNormal];
    }
    [self.alertView addSubview:confirmButton];
    
        // Add a left Border.
    [self addABorderTo:confirmButton on:@"left" useColor:borderColor];
    
        //Set the buttons' functions.
    [cancelButton addTarget:self action:@selector(buttonEventCancel) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton addTarget:self action:@selector(buttonEventConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Add to root view.
    [self addSubview:self.alertView];
}

- (void)addABorderTo:(UIView *)view on:(NSString *)position useColor:(CGColorRef)borderColor{
    // Add Border.
    CALayer *border = [CALayer layer];

    if([position isEqualToString: @"bottom"]){
        border.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, 0.5);
    }
    else if([position isEqualToString:@"left"]){
        border.frame = CGRectMake(0, 0, 0.5, view.frame.size.height);
    }
    
    border.backgroundColor = borderColor;
    [view.layer addSublayer:border];
}

- (void)buttonEventConfirm{
    [_delegate didConfirmButtonPressed];
    
    [self dismissFromSender:@"confirm"];
}

- (void)buttonEventCancel{
    if([_delegate respondsToSelector:@selector(didCancelButtonPressed)]){
        [_delegate didCancelButtonPressed];
    } 
    
    [self dismissFromSender:@"cancel"];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}
*/

@end

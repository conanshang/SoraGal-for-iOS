//
//  TCustomAlertView.h
//  Test
//
//  Created by conans on 4/5/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

//Delegate to handle button events.
@class TCustomAlertView;
@protocol TCustomAlertViewDelegate <NSObject>

@optional
- (void)didConfirmButtonPressed;
- (void)didCancelButtonPressed;
- (void)didAlertViewDisappeared;

@end


@interface TCustomAlertView : UIView

- (id)initWithSuperView:(UIView *)superView;
- (id)initWithSuperView:(UIView *)superView title:(NSString *)title andDetail:(NSString *)detail;
- (id)initWithSuperView:(UIView *)superView title:(NSString *)title detail:(NSString *)detail confirmText:(NSString *)confirmText andCancelText:(NSString *)cancelText;

- (void)show;
- (void)dismiss;

@property (nonatomic, strong) NSString *tittleText;
@property (nonatomic, strong) NSString *detailText;
@property (nonatomic, strong) NSString *confirmText;
@property (nonatomic, strong) NSString *cancelText;

@property CGFloat alertViewBorderRadius;
@property (nonatomic, strong) UIColor *confirmColor;
@property (nonatomic, strong) UIColor *cancelColor;

@property (nonatomic, weak) id <TCustomAlertViewDelegate> delegate;

@end

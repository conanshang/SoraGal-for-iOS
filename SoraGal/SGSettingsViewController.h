//
//  SGSettingsViewController.h
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGSettingsViewController;

@protocol SGSettingsViewControllerDelegate <NSObject>

@optional
- (void)shouldChangeDialogBoxTransparency:(float)OpaqueValue;
- (void)shouldCHangeDialogTextDisplaySpeed:(float)displaySpeed;
- (void)shouldChangeBackgroundFillType:(BOOL)ifFillTheScreen;

- (void)shouldChangeBackgroundMusicVolume:(float)volume;
- (void)shouldChangeVoiceVolume:(float)volume;

@end

@interface SGSettingsViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *settingsStatus;

@property (nonatomic, weak) id <SGSettingsViewControllerDelegate> viewRelatedDelegate;
@property (nonatomic, weak) id <SGSettingsViewControllerDelegate> audioDelegate;

@end

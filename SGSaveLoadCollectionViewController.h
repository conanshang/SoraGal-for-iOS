//
//  SGSaveLoadCollectionViewController.h
//  SoraGal
//
//  Created by conans on 2/23/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Save Game UICollectionViewController

@class SGSaveCollectionViewController;
//Delegate
@protocol SGSaveCollectionViewControllerDelegate <NSObject>

@required
- (NSDictionary *)returnCurrentGameStatus;
- (UIImage *)returnCurrentScreenshot;

@end

//Interface
@interface SGSaveCollectionViewController : UICollectionViewController

@property (nonatomic, weak) id <SGSaveCollectionViewControllerDelegate> delegate;

@end


#pragma mark - Load Game UICollectionViewController

@class SGLoadCollectionViewController;
//Delegate
@protocol SGLoadCollectionViewControllerDelegate <NSObject>

@required
- (BOOL)reloadGameStatus:(NSDictionary *)gameStatus;

@end

//Interface
@interface SGLoadCollectionViewController : UICollectionViewController

@property (nonatomic, weak) id <SGLoadCollectionViewControllerDelegate> delegate;

@end


#pragma mark - Custom the UICollectionViewFlowLayout

@interface SGCustomCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
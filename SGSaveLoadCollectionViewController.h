//
//  SGSaveLoadCollectionViewController.h
//  SoraGal
//
//  Created by conans on 2/23/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCustomAlertView.h"

#pragma mark - Base CollectionViewController

@class SGCustomCollectionViewFlowLayout;
@interface SGBaseCollectionViewController : UICollectionViewController <UICollectionViewDelegate, TCustomAlertViewDelegate>

/* Reusing methods. For in the same file, so it's no need to write in the public area. */
//- (void)setupTheLayout:(SGCustomCollectionViewFlowLayout *)layout forCollectionView:(UICollectionView *)collectionView;
//- (void)loadGameSavingFileToArray:(NSArray *)receivingArray;
//- (void)checkIfNeedToCreateTheSaveDataFolder;
//- (UIImage *)getSaveDataScreenShotImageByName:(NSString *)screenshotName;
//- (NSString *)createCreationTimeString:(NSDate *)date forTimeOrDate:(NSInteger)typeInteger;

@end

#pragma mark - Save Game UICollectionViewController

@class SGSaveCollectionViewController;
//Delegate
@protocol SGSaveCollectionViewControllerDelegate <NSObject>

@required
- (NSDictionary *)returnCurrentGameStatus;
- (UIImage *)returnCurrentScreenshot;

@end

//Interface
@interface SGSaveCollectionViewController : SGBaseCollectionViewController

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
@interface SGLoadCollectionViewController : SGBaseCollectionViewController

@property (nonatomic, weak) id <SGLoadCollectionViewControllerDelegate> delegate;

@end


#pragma mark - Custom the UICollectionViewFlowLayout

@interface SGCustomCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
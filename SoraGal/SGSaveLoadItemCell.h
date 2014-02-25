//
//  SGSaveLoadItemCell.h
//  SoraGal
//
//  Created by conans on 2/23/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGSaveLoadItemCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView *saveDataScreenShotImage;
@property (nonatomic, strong) NSString *saveDateCreationDateString;
@property (nonatomic, strong) NSString *saveDateCreationTimeString;

@end

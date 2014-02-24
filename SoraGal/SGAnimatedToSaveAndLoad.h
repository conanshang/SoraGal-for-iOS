//
//  SGAnimatedToSaveAndLoad.h
//  SoraGal
//
//  Created by conans on 2/23/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGAnimatedToSaveAndLoad : NSObject <UIViewControllerAnimatedTransitioning>

@property BOOL ifInAnimating;
@property BOOL ifToSaveCollectionViewController;

@end

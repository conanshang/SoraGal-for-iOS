//
//  SGAnimatedToSaveAndLoad.m
//  SoraGal
//
//  Created by conans on 2/23/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGAnimatedToSaveAndLoad.h"

@implementation SGAnimatedToSaveAndLoad

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Set our ending frame. We'll modify this later if we have to
    CGRect endFrame = CGRectMake(0, 0, 320 , 568);
    
    if (self.ifInAnimating) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = endFrame;
        if(self.ifToSaveCollectionViewController){
            startFrame.origin.y += 568;
        }
        else{
            startFrame.origin.y -= 568;
        }
        
        toViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        if(self.ifToSaveCollectionViewController){
            endFrame.origin.y += 568;
        }
        else{
            endFrame.origin.y -= 568;
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            fromViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end

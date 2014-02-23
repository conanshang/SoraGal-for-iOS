//
//  SGViewController.m
//  SoraGal
//
//  Created by conans on 1/13/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGViewController.h"
#import "SGDialogView.h"
#import "SGAudioModule.h"
#import "SGSettingsViewController.h"
#import "SGAnimationToSettings.h"
#import "SGCommandFormater.h"

#define IMAGEVIEW_TRANSITION_TIME_DEFAULT 300.00
#define IMAGEVIEW_TRANSITION_TIME_MAX 5000.00

@interface SGViewController () <SGSettingsViewControllerDelegate, UIViewControllerTransitioningDelegate>

//The view conponents.
@property (weak, nonatomic) IBOutlet UIImageView *CGView;
@property (weak, nonatomic) IBOutlet UIImageView *CHView;
@property (weak, nonatomic) IBOutlet SGDialogView *dialogView;

//Class instance properties.
@property (nonatomic, strong) SGAudioModule *soraGalAudioModule;
@property (nonatomic, strong) SGCommandFormater *soraGalCommandFormatter;

//Private variables.
@property (nonatomic, strong) NSMutableDictionary *settingsSavingDictionary;
@property (nonatomic, strong) NSArray *currentCommands;

@property dispatch_queue_t getNextCommandQ;

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Initial all the settings.
    [self initialAllSettings];
    
    //Run the test functions.
    [self testTheFunctions];
}

//Initialize the viewController settings.
- (void)initialAllSettings{
    self.dialogView.dialogAlpha = 1.0; //Set the initial alpha to 0.5.
    self.dialogView.dialogTextDisplaySpeedInSecond = 0.05; //Set the dialog text display speed to per letter/0.05s.
    
    self.soraGalAudioModule = [[SGAudioModule alloc] init]; //Create the instance of audio module.
    
    //Create the instance of command formatter in another queue.
    self.getNextCommandQ = dispatch_queue_create("getNextCommand", NULL);
    dispatch_async(self.getNextCommandQ, ^{
        self.soraGalCommandFormatter = [[SGCommandFormater alloc] init];
    });
}


#pragma mark - Views related methods.
//Set the transition style of changing images.
- (BOOL)updateTransitionStyleForImageView:(UIImageView *)theImageView withTransitionTime:(float)transitionTime{
    transitionTime = transitionTime / 1000.00;
    
    if((transitionTime > 0) && (transitionTime < IMAGEVIEW_TRANSITION_TIME_MAX)){
        //Clear old transition style.
        [theImageView.layer removeAllAnimations];
        
        //Create new transition style.
        CATransition *transition = [CATransition animation];
        transition.duration = transitionTime;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        
        //Apply new transition style.
        [theImageView.layer addAnimation:transition forKey:nil];
        
        return YES;
    }
    else{
        [self updateTransitionStyleForImageView:theImageView withTransitionTime:IMAGEVIEW_TRANSITION_TIME_DEFAULT];
        
        return YES;
    }
    
    return NO;
}

//Change the Background image.
- (void)changeBackground:(NSString *)bgName withType:(NSString *)imageType andTransitionTime:(float)transitionTime{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Change the transition style.
        [self updateTransitionStyleForImageView:self.CGView withTransitionTime:transitionTime];
        
        //Get the image.
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:bgName ofType:imageType inDirectory:@"GameData/BGs"];
        UIImage *imageBG = [[UIImage alloc] initWithContentsOfFile:imagePath];
        
        //Set the image.
        if(imageBG != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.CGView.image = imageBG;
            });
        }
    });
}

//Change the CG image.
- (void)changeCGImage:(NSString *)cgName withType:(NSString *)imageType andTransitionTime:(float)transitionTime{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Change the transition style.
        [self updateTransitionStyleForImageView:self.CGView withTransitionTime:transitionTime];
        
        //Get the image.
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:cgName ofType:imageType inDirectory:@"GameData/CGs"];
        UIImage *imageCG = [[UIImage alloc] initWithContentsOfFile:imagePath];
        
        //Set the image.
        if(imageCG != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.CGView.image = imageCG;
            });
        }
    });
}

//Change the CG image with pure color.
- (void)changePureColorBackground:(NSString *)rgbColor andTransitionTime:(float)transitionTime{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Change the transition style.
        [self updateTransitionStyleForImageView:self.CGView withTransitionTime:transitionTime];
        
        UIColor *pureColor;
        if([rgbColor characterAtIndex:0] == '#'){
            //Seperate the color string.
            NSString *rgbValue = [rgbColor substringFromIndex:1];
            NSUInteger rgbValueAverageLength = [rgbValue length] / 3;
            
            NSRange range;
            range.location = 0;
            range.length = rgbValueAverageLength;
            
            NSString *red = [rgbValue substringWithRange:range];
            
            range.location = range.location + rgbValueAverageLength;
            NSString *green = [rgbValue substringWithRange:range];
            
            range.location = range.location + rgbValueAverageLength;
            NSString *blue = [rgbValue substringWithRange:range];
            
            //Get color's float value.
            unsigned r = 0;
            NSScanner *redColorScanner = [NSScanner scannerWithString:red];
            [redColorScanner scanHexInt:&r];
            
            unsigned g = 0;
            NSScanner *greenColorScanner = [NSScanner scannerWithString:green];
            [greenColorScanner scanHexInt:&g];
            
            unsigned b = 0;
            NSScanner *blueColorScanner = [NSScanner scannerWithString:blue];
            [blueColorScanner scanHexInt:&b];
            
            //Create the color.
            pureColor = [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
        }
        else{
            pureColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        }
        
        //Set the image.
        if(pureColor){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.CGView.image = nil;
                self.CGView.backgroundColor = pureColor;
            });
        }
    });
}

//Chnage the character image.
- (BOOL)changeCharacterImage:(NSString *)chName withType:(NSString *)chType andTransitionTime:(float)transitionTime{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:chName ofType:chType inDirectory:@"GameData/CHs"];
    UIImage *imageCH = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    if(imageCH != nil){
        self.CHView.image = imageCH;
        
        return YES;
    }
    
    return NO;
}

//Display the dialog.
- (void)showDialog:(NSString *)characterName andText:(NSString *)dialogText{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *localCharacterName = characterName;
        NSString *localDialogText = dialogText;
        
        if((![localCharacterName isEqualToString:@""]) && (localCharacterName != nil)){
            if([localCharacterName length] > 25){
                localCharacterName = [localCharacterName substringToIndex:99];
                
                NSLog(@"Charater name text exceed max length.");
            }
            self.dialogView.dialogName = [localCharacterName stringByAppendingString:@"："];
        }
        else{
            self.dialogView.dialogName = @"";
        }
        
        if([localDialogText length] > 140){
            localDialogText = [localDialogText substringToIndex:139];
            
            NSLog(@"Dialog text exceed max length in a single page.");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dialogView.dialogText = localDialogText;
        });
    });
}


#pragma mark - Audio and video controlling methods.
- (void)playBackgroundMusic:(NSString *)bgmName andType:(NSString *)bgmType{
    [self.soraGalAudioModule playBackgroundMusic:bgmName andType:bgmType];
}

- (void)stopBackgroundMusic{
    [self.soraGalAudioModule stopBackgroundMusic];
}

- (void)playCharacterVoice:(NSString *)voiceName andType:(NSString *)voiceType{
    [self.soraGalAudioModule playCharacterVoice:voiceName andType:voiceType];
}

- (void)stopCharacterVoice{
    [self.soraGalAudioModule stopCharacterVoice];
}


#pragma mark - Segues.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SoraGalSettings"]){
        SGSettingsViewController *settingsViewController = segue.destinationViewController;
        
        settingsViewController.audioDelegate = (id)self.soraGalAudioModule; //Set the delegate for audio related settings.
        settingsViewController.viewRelatedDelegate = (id)self; //Set the delegate for view related settings.
        
        settingsViewController.settingsStatus = self.settingsSavingDictionary; //Pass the data.
        
        //Custom transition.
        settingsViewController.transitioningDelegate = self;
        settingsViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    else if([segue.identifier isEqualToString:@"saveAndLoad"]){
        //UITabBarController *tabBarController = segue.destinationViewController;
        
        //Custom transition.
        //tabBarController.transitioningDelegate = self;
        //tabBarController.modalPresentationStyle = UIModalPresentationCustom;
    }
}

- (IBAction)unwindFromSettings:(UIStoryboardSegue *)sender {
    SGSettingsViewController *receivedSettingsViewController = sender.sourceViewController;
    self.settingsSavingDictionary = receivedSettingsViewController.settingsStatus;
}

#pragma mark - SGSettingsViewController Delegate
- (void)shouldChangeDialogBoxTransparency:(float)OpaqueValue{
    self.dialogView.dialogAlpha = 1 - OpaqueValue;  //Change the alpha of dialog box.
}

- (void)shouldCHangeDialogTextDisplaySpeed:(float)displaySpeed{
    self.dialogView.dialogTextDisplaySpeedInSecond = displaySpeed;
}

- (void)shouldChangeBackgroundFillType:(BOOL)ifFillTheScreen{
    if(ifFillTheScreen){
        self.CGView.contentMode = UIViewContentModeScaleAspectFill;
    }
    else{
        self.CGView.contentMode = UIViewContentModeScaleAspectFit;
    }
}


#pragma mark - Custom modal segue transition Delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source{
    
    if([presented.title isEqualToString:@"SGSettingsViewController"]){
        SGAnimationToSettings *animator = [SGAnimationToSettings new];
        
        animator.ifInAnimating = YES;
        
        return animator;
    }
    else if([presented.title isEqualToString:@"SGSaveLoadTabBarController"]){
        SGAnimationToSettings *animator = [SGAnimationToSettings new];
        
        animator.ifInAnimating = YES;
        
        return animator;
    }
    
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    if([dismissed.title isEqualToString:@"SGSettingsViewController"]){
        SGAnimationToSettings *animator = [SGAnimationToSettings new];
        
        animator.ifInAnimating = NO;
        
        return animator;
    }
    
    return nil;
}


#pragma mark - Execute script commands.
- (IBAction)tappedForNextCommand:(id)sender {
    dispatch_async(self.getNextCommandQ, ^{
        //Get a non-nil commands array.
        self.currentCommands = [self.soraGalCommandFormatter getNextCommand];
        if(!self.currentCommands){
            self.currentCommands = [self.soraGalCommandFormatter getNextCommand];
        }
        
        for(int i = 0; i < [self.currentCommands count]; i++){
            NSArray *command = [self.currentCommands objectAtIndex:i];
            NSString *commandName = [command objectAtIndex:0];
            
            if([commandName isEqualToString:@"showDialog"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showDialog:[command objectAtIndex:1] andText:[command objectAtIndex:2]];
                });
            }
            else if([commandName isEqualToString:@"playCharacterVoice"]){
                [self playCharacterVoice:[command objectAtIndex:1] andType:[command objectAtIndex:2]];
            }
            else if([commandName isEqualToString:@"changeBackground"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self changeBackground:[command objectAtIndex:1] withType:[command objectAtIndex:2] andTransitionTime:[[command objectAtIndex:3] floatValue]];
                });
            }
            else if([commandName isEqualToString:@"changeCGImage"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self changeCGImage:[command objectAtIndex:1] withType:[command objectAtIndex:2] andTransitionTime:[[command objectAtIndex:3] floatValue]];
                });
            }
            else if([commandName isEqualToString:@"changeCharacterImage"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self changeCharacterImage:[command objectAtIndex:1] withType:[command objectAtIndex:2] andTransitionTime:[[command objectAtIndex:3] floatValue]];
                });
            }
            else if([commandName isEqualToString:@"playBackgroundMusic"]){
                [self playBackgroundMusic:[command objectAtIndex:1] andType:[command objectAtIndex:2]];
            }
            else if([commandName isEqualToString:@"changePureColorBackground"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self changePureColorBackground:[command objectAtIndex:1] andTransitionTime:[[command objectAtIndex:2] floatValue]];
                });
            }
            
            NSLog(@"SGViewController : Command : %@ \n", commandName);
        }
     
    });
}

#pragma mark - Test methods.
- (void)testTheFunctions{
    //[self changeBackground:@"B04a" withType:@"jpg" andTransitionTime:1.0];
    [self changeCGImage:@"eden_2" withType:@"jpg" andTransitionTime:500.0];
    //[self changePureColorBackground:@"#000"];
    //[self showDialog:@"悠" andText:@"我本以为,自由我才会有这种稀奇古怪的想法吧,可没想到的是前几天看的推理小说中,里面的犯人也和我同样的幻想着."];
    //[self.soraGalAudioModule playBackgroundMusic:@"02" andType:@"m4a"];
    //[self.soraGalAudioModule playCharacterVoice:@"16" andType:@"m4a"];
    //[self changeCharacterImage:@"CA01_01S" withType:@"png" andTransitionTime:1.0];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can b recreated.
}























@end

























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

@interface SGViewController () <SGSettingsViewControllerDelegate>

//The view conponents.
@property (weak, nonatomic) IBOutlet UIImageView *CGView;
@property (weak, nonatomic) IBOutlet UIImageView *CHView;
@property (weak, nonatomic) IBOutlet SGDialogView *dialogView;

//Class properties.
@property (nonatomic, strong) SGAudioModule *soraGalAudioModule;

//Private variables.
@property (nonatomic, strong) NSMutableDictionary *settingsSavingDictionary;

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
    
    self.soraGalAudioModule = [[SGAudioModule alloc] init]; //Create the instance of audio module.
}


#pragma mark - Views controlling methods.
//Change the Background image.
- (BOOL)changeBackground:(NSString *)bgName withType:(NSString *)imageType andTransitionTime:(float)transitionTime{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:bgName ofType:imageType inDirectory:@"GameData/BGs"];
    UIImage *imageBG = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    if(imageBG != nil){
        self.CGView.image = imageBG;
        
        return YES;
    }
    
    return NO;
}

//Change the CG image.
- (BOOL)changeCGImage:(NSString *)cgName withType:(NSString *)imageType andTransitionTime:(float)transitionTime{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:cgName ofType:imageType inDirectory:@"GameData/CGs"];
    UIImage *imageCG = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    if(imageCG != nil){
        self.CGView.image = imageCG;
        
        return YES;
    }
    
    return NO;
}

//Change the CG image with pure color.
- (BOOL)changePureColorBackground:(NSString *)rgbColor{
    UIColor *pureColor;
    
    char colorIndicator = [rgbColor characterAtIndex:0];
    if(colorIndicator == '#'){
        NSString *rgbValue = [rgbColor substringFromIndex:1];
        NSUInteger rgbValueAverageLength = [rgbValue length] / 3;
        
        NSRange range;
        range.location = 0;
        range.length = rgbValueAverageLength;
        
        float r = [[rgbValue substringWithRange:range] integerValue] / 255.0;
        
        range.location = range.location + rgbValueAverageLength;
        float g = [[rgbValue substringWithRange:range] integerValue] / 255.0;
        
        range.location = range.location + rgbValueAverageLength;
        float b = [[rgbValue substringWithRange:range] integerValue] / 255.0;
        
        pureColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    }
    
    if(pureColor){
        self.CGView.backgroundColor = pureColor;
        
        return YES;
    }
    
    return NO;
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
    if(characterName != nil){
        if([characterName length] > 25){
            characterName = [characterName substringToIndex:99];
            
            NSLog(@"Charater name text exceed max length.");
        }
        self.dialogView.dialogName = [characterName stringByAppendingString:@"："];
    }
    else{
        self.dialogView.dialogName = @"";
    }

    if([dialogText length] > 140){
        dialogText = [dialogText substringToIndex:139];
        
        NSLog(@"Dialog text exceed max length in a single page.");
    }
    self.dialogView.dialogText = dialogText; 
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
        
        settingsViewController.settingsStatus = self.settingsSavingDictionary;
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

- (void)shouldChangeBackgroundFillType:(BOOL)ifFillTheScreen{
    if(ifFillTheScreen){
        self.CGView.contentMode = UIViewContentModeScaleAspectFill;
    }
    else{
        self.CGView.contentMode = UIViewContentModeScaleAspectFit;
    }
}



- (void)testTheFunctions{
    //[self changeBackground:@"B04a" withType:@"jpg" andTransitionTime:1.0];
    [self changeCGImage:@"EA01a" withType:@"jpg" andTransitionTime:1.0];
    //[self changePureColorBackground:@"#255255255"];
    [self showDialog:@"悠" andText:@"我本以为,自由我才会有这种稀奇古怪的想法吧,可没想到的是前几天看的推理小说中,里面的犯人也和我同样的幻想着."];
    [self.soraGalAudioModule playBackgroundMusic:@"02" andType:@"m4a"];
    //[self.soraGalAudioModule playCharacterVoice:@"e1" andType:@"wav"];
    //[self changeCharacterImage:@"CA01_01S" withType:@"png" andTransitionTime:1.0];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can b recreated.
}























@end

























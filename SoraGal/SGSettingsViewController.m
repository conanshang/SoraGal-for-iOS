//
//  SGSettingsViewController.m
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGSettingsViewController.h"

@interface SGSettingsViewController ()

//The UI elements.
@property (weak, nonatomic) IBOutlet UISlider *dialogBoxOpaqueSlider;
@property (weak, nonatomic) IBOutlet UISlider *bgmVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *voiceVolumeSlider;
@property (weak, nonatomic) IBOutlet UISwitch *cgModeSwitch;

@end

@implementation SGSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//Load or initial the settingsStatus.
    if(!self.settingsStatus){
        self.settingsStatus = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    else{
        [self loadPreviousSettings];
    }
}

- (void)loadPreviousSettings{
    self.dialogBoxOpaqueSlider.value = [[self.settingsStatus objectForKey:@"dialogBoxOpaque"] floatValue];
    self.bgmVolumeSlider.value = [[self.settingsStatus objectForKey:@"bgmVolume"] floatValue];
    self.voiceVolumeSlider.value = [[self.settingsStatus objectForKey:@"voiceVolume"] floatValue];
    self.cgModeSwitch.on = [[self.settingsStatus objectForKey:@"cgMode"] boolValue];
}

//The settings.
- (IBAction)dialogBoxOpaqueSlider:(id)sender {
    UISlider *dialogBoxTransparencySlider = sender;
    //Use delegate to change the transparency of dialog box in realtime.
    [_viewRelatedDelegate shouldChangeDialogBoxTransparency:dialogBoxTransparencySlider.value];
}

- (IBAction)bgmVolumeSlider:(id)sender {
    UISlider *bgmSlider = sender;
    [self.audioDelegate shouldChangeBackgroundMusicVolume:bgmSlider.value];
}

- (IBAction)voiceVolumeSlider:(id)sender {
    UISlider *voiceSlider = sender;
    [_audioDelegate shouldChangeVoiceVolume:voiceSlider.value];
}

- (IBAction)cgModeSwitch:(id)sender {
    UISwitch *cgMSwitch = sender;
    [_viewRelatedDelegate shouldChangeBackgroundFillType:cgMSwitch.on];
}

//Doing something before unwind.
- (void)saveSettingsStatus{
    [self.settingsStatus setObject:[NSNumber numberWithFloat:self.dialogBoxOpaqueSlider.value] forKey:@"dialogBoxOpaque"];
    [self.settingsStatus setObject:[NSNumber numberWithFloat:self.bgmVolumeSlider.value] forKey:@"bgmVolume"];
    [self.settingsStatus setObject:[NSNumber numberWithFloat:self.voiceVolumeSlider.value] forKey:@"voiceVolume"];
    [self.settingsStatus setObject:[NSNumber numberWithBool:self.cgModeSwitch.on] forKey:@"cgMode"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [self saveSettingsStatus];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end

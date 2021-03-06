//
//  SGAudioModule.m
//  SoraGal
//
//  Created by conans on 2/13/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SGAudioModule.h"
#import "SGSettingsViewController.h"

@interface SGAudioModule() <SGSettingsViewControllerDelegate>

@property (strong, nonatomic) AVAudioPlayer *backgroundPlayer;
@property (strong, nonatomic) AVAudioPlayer *voicePlayer;

@property dispatch_queue_t audioPlayerQ;

@property (nonatomic) float backgroundMusicVolume;
@property (nonatomic) float voiceVolume;

@end

@implementation SGAudioModule

- (id)init{
    self = [super init];
    if(self){
        self.backgroundMusicVolume = 0.5;
        self.voiceVolume = 0.5;
        
        self.audioPlayerQ = dispatch_queue_create("audioPlayer", NULL);
    }
    return self;
}

- (void)setBackgroundMusicVolume:(float)backgroundMusicVolume{
    if(_backgroundMusicVolume != backgroundMusicVolume){
        _backgroundMusicVolume = backgroundMusicVolume;
        
        if(self.backgroundPlayer){
            dispatch_async(self.audioPlayerQ, ^{
                self.backgroundPlayer.volume = backgroundMusicVolume;
            });
        }
    }
}

- (void)setVoiceVolume:(float)voiceVolume{
    if(_voiceVolume != voiceVolume){
        _voiceVolume = voiceVolume;
        
        if(self.voicePlayer){
            dispatch_async(self.audioPlayerQ, ^{
                self.voicePlayer.volume = voiceVolume;
            });
        }
    }
}

- (void)playBackgroundMusic:(NSString *)bgmName andType:(NSString *)bgmType{
    [self stopBackgroundMusic];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *bgmFilePath = [[NSBundle mainBundle] pathForResource:bgmName ofType:bgmType inDirectory:@"GameData/BGMs"];
        
        if(bgmFilePath){
            dispatch_async(self.audioPlayerQ, ^{
                NSURL *soundFileURL = [NSURL fileURLWithPath:bgmFilePath];
                self.backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
                
                if(self.backgroundPlayer){
                    self.backgroundPlayer.numberOfLoops = -1;
                    self.backgroundPlayer.volume = self.backgroundMusicVolume;
                    [self.backgroundPlayer play];
                }
            });
        }
        else{
            NSLog(@"Can't find the requested BGM file.");
        }
    });
}

- (void)stopBackgroundMusic{
    if(self.backgroundPlayer){
        dispatch_async(self.audioPlayerQ, ^{
            [self.backgroundPlayer stop];
        });
    }

    self.backgroundPlayer = nil;
}

- (void)playCharacterVoice:(NSString *)voiceName andType:(NSString *)voiceType{
    [self stopCharacterVoice];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *voiceFilePath = [[NSBundle mainBundle] pathForResource:voiceName ofType:voiceType inDirectory:@"GameData/Voices"];
        
        if(voiceFilePath){
            dispatch_async(self.audioPlayerQ, ^{
                NSURL *soundFileURL = [NSURL fileURLWithPath:voiceFilePath];
                self.voicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
                
                if(self.voicePlayer){
                    self.voicePlayer.numberOfLoops = 0;
                    self.voicePlayer.volume = self.voiceVolume;
                    [self.voicePlayer play];
                }
            });
        }
        else{
            NSLog(@"Can't find the requested voice file.");
        }
    });
}

- (void)stopCharacterVoice{
    if(self.voicePlayer){
        dispatch_async(self.audioPlayerQ, ^{
            [self.voicePlayer stop];
        });
    }
    
    self.voicePlayer = nil;
}


#pragma mark - SGSettingsViewController Delegate
- (void)shouldChangeBackgroundMusicVolume:(float)volume{
    self.backgroundMusicVolume = volume;
}

- (void)shouldChangeVoiceVolume:(float)volume{
    self.voiceVolume = volume;
}




















@end

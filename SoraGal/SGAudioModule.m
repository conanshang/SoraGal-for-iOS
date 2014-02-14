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

@interface SGAudioModule()

@property (strong, nonatomic) AVAudioPlayer *backgroundPlayer;
@property (strong, nonatomic) AVAudioPlayer *voicePlayer;

@property dispatch_queue_t backgroundPlayerQ;
@property dispatch_queue_t characterVoicePlayerQ;

@end

@implementation SGAudioModule

- (void)playBackgroundMusic:(NSString *)bgmName andType:(NSString *)bgmType{
    [self stopBackgroundMusic];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:bgmName ofType:bgmType];
    
    if(soundFilePath){
        self.backgroundPlayerQ = dispatch_queue_create("backgroundPlayer", NULL);
        
        dispatch_async(self.backgroundPlayerQ, ^{
            NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
            self.backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
            
            if(self.backgroundPlayer){
                self.backgroundPlayer.numberOfLoops = -1;
                [self.backgroundPlayer play];
            }
        });
    }
    else{
        NSLog(@"Can't find the requested BGM file.");
    }
}

- (void)stopBackgroundMusic{
    if(self.backgroundPlayer){
        dispatch_async(self.backgroundPlayerQ, ^{
            [self.backgroundPlayer stop];
        });
    }

    self.backgroundPlayer = nil;
}

- (void)playCharacterVoice:(NSString *)voiceName andType:(NSString *)voiceType{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:voiceName ofType:voiceType];
    
    if(soundFilePath){
        self.characterVoicePlayerQ = dispatch_queue_create("characterVoicePlayer", NULL);
        
        dispatch_async(self.characterVoicePlayerQ, ^{
            NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
            self.voicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
            
            if(self.voicePlayer){
                self.voicePlayer.numberOfLoops = 0;
                [self.voicePlayer play];
            }
        });
    }
    else{
        NSLog(@"Can't find the requested voice file.");
    }
}

- (void)stopCharacterVoice{
    if(self.voicePlayer){
        dispatch_async(self.characterVoicePlayerQ, ^{
            [self.voicePlayer stop];
        });
    }
    
    self.voicePlayer = nil;
}

@end

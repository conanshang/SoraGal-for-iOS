//
//  SGAudioModule.h
//  SoraGal
//
//  Created by conans on 2/13/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGAudioModule : NSObject

- (void)playBackgroundMusic:(NSString *)bgmName andType:(NSString *)bgmType;
- (void)stopBackgroundMusic;

- (void)playCharacterVoice:(NSString *)voiceName andType:(NSString *)voiceType;
- (void)stopCharacterVoice;

@end

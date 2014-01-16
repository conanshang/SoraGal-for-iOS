//
//  SGScriptReader.m
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGScriptReader.h"

@interface SGScriptReader()

@property (nonatomic, strong) NSString *dataString;
@property NSUInteger scriptStringLength;
@property NSUInteger currentPosition;

@end

@implementation SGScriptReader

- (id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (id)initWithString:(NSString *)scriptString{
    self = [super init];
    if(self){
        if(!scriptString){
            scriptString = [[NSString alloc] init];
        }
        self.dataString = scriptString;
        self.scriptStringLength = [scriptString length];
        self.currentPosition = 0;
    }
    return self;
}

- (unichar)nextCharacter{
    unichar nextChar = 0;
    //If the reveived script is empty.
    if(self.currentPosition >= self.scriptStringLength){
        nextChar = -1;
    }
    //For Windows format txt, which new line mark is /r/n.
    if(([self.dataString characterAtIndex:self.currentPosition + 1] == '\r') && ([self.dataString characterAtIndex:self.currentPosition + 2] == '\n')){
        self.currentPosition += 2;
        nextChar = [self.dataString characterAtIndex:self.currentPosition];
    }
    else{
        self.currentPosition++;
        nextChar = [self.dataString characterAtIndex:self.currentPosition];
    }

    return nextChar;
}

- (void)retractNCharacter:(NSUInteger) n{
    if(self.currentPosition < n){
        self.currentPosition = 0;
    }
    else{
        self.currentPosition -= n;
    }
}

@end

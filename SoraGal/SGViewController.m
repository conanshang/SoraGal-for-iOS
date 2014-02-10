//
//  SGViewController.m
//  SoraGal
//
//  Created by conans on 1/13/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGViewController.h"
#import "SGDialogView.h"

@interface SGViewController ()

//The view conponents.
@property (weak, nonatomic) IBOutlet UIImageView *CGView;
@property (weak, nonatomic) IBOutlet SGDialogView *dialogView;


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
}


/*** Views controlling methods.  */

//Change the CG image.
- (BOOL)changeCGBackground:(NSString *)cgName withType:(NSString *)imageType andTransitionTime:(float)transitionTime{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:cgName ofType:imageType];
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



/** Ends views controlling methods. */













//Setting parts.
//Change the alpha of dialog box.
- (IBAction)dialogAlphaChangingSlider:(id)sender {
    UISlider *slider = sender;
    self.dialogView.dialogAlpha = slider.value;
    
}




- (void)testTheFunctions{
    [self changeCGBackground:@"eden_1" withType:@"jpg" andTransitionTime:1.0];
    //[self changePureColorBackground:@"#255255255"];
    [self showDialog:@"悠" andText:@"我本以为自由我才会有这种稀奇古怪的想法吧可没想到的是前几天看的推理小说中里面的犯人也和我同样的幻想着蔚蓝的天空让人觉得异常清澈不同城市的天空纯粹的蓝和天空一样连白云都显示出了和城市中所不一天的异彩不禁让人有果然是空气清新啊这种想法我心中那份微弱的旅行的热情也冷却下来。"];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can b recreated.
}

@end

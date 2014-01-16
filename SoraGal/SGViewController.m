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

@property (weak, nonatomic) IBOutlet SGDialogView *dialogView;

@property (weak, nonatomic) IBOutlet UIImageView *CGView;

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self initialAllSettings];
    [self putCGImage:@"eden_1" andType:@"jpg"];
}

//Use to set everything when loading.
- (void)initialAllSettings{
    self.dialogView.dialogAlpha = 0.5; //Set the initial alpha to 0.5.
}

//Change the CG image.
- (void)putCGImage:(NSString *)imageName andType:(NSString *)imageType{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
    UIImage *imageCG = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    if(imageCG != nil){
        self.CGView.image = imageCG;
    }
    
}

//Change the alpha of dialog box.
- (IBAction)dialogAlphaChangingSlider:(id)sender {
    UISlider *slider = sender;
    self.dialogView.dialogAlpha = slider.value;
    
}













- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

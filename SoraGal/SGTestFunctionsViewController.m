//
//  SGTestFunctionsViewController.m
//  SoraGal
//
//  Created by conans on 1/16/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGTestFunctionsViewController.h"
#import "SGScriptReader.h"


@interface SGTestFunctionsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *testDialogView;

@property (strong, nonatomic) NSString *testDialogString;

@property (strong, nonatomic) SGScriptReader *testScriptReader;

@end

@implementation SGTestFunctionsViewController

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
	
    [self getStringDataFromFile];
    [self displayCharInTextView];
}

- (void)getStringDataFromFile{
    //The path of the script txt.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scriptExample" ofType:@"txt"];
    //Put the script to a string.
    self.testDialogString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)displayCharInTextView{
    self.testScriptReader = [[SGScriptReader alloc] initWithString:self.testDialogString];
    unichar nextChar = [self.testScriptReader nextCharacter];
    NSString *theString = [NSString stringWithCharacters:&nextChar length:1];
    
    int n = 60;
    while(n>0){
        nextChar = [self.testScriptReader nextCharacter];
        NSString *newString = [NSString stringWithCharacters:&nextChar length:1];
        theString = [theString stringByAppendingString:newString];
        
        n--;
    }
    
    self.testDialogView.text = theString;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

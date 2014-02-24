//
//  SGSaveLoadCollectionViewController.m
//  SoraGal
//
//  Created by conans on 2/23/14.
//  Copyright (c) 2014 Zihang Wang. All rights reserved.
//

#import "SGSaveLoadCollectionViewController.h"
#import "SGSaveLoadItemCell.h"

#pragma mark - Save Game UICollectionViewController

@interface SGSaveCollectionViewController ()

@property (strong, nonatomic) IBOutlet SGCustomCollectionViewFlowLayout *saveCollectionViewFlowLayout;

@end

@implementation SGSaveCollectionViewController

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
    
    //Register the class.
    [self.collectionView registerClass:[SGSaveLoadItemCell class] forCellWithReuseIdentifier:@"saveGameCollectionCell"];
    
    //Setup the layout.
    [self setupTheLayout];
}

- (void)setupTheLayout{
    //Setup the flow layout.
    self.saveCollectionViewFlowLayout = [[SGCustomCollectionViewFlowLayout alloc] init];
    [self.saveCollectionViewFlowLayout setItemSize:CGSizeMake(279, 108)]; //The cell's size.
    [self.saveCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.saveCollectionViewFlowLayout.minimumLineSpacing = 2.0f;
    
    //Setup the collectionView.
    [self.collectionView setCollectionViewLayout:self.saveCollectionViewFlowLayout];
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"saveGameCollectionCell";
    
    SGSaveLoadItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"eden_1" ofType:@"jpg" inDirectory:@"GameData/CGs"];
    cell.saveDataScreenShotImage.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    return cell;
}

- (IBAction)exitSaveGameScreen:(id)sender {
    //NSLog(@"Exit");
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



#pragma mark - Load Game UICollectionViewController

@interface SGLoadCollectionViewController ()

@property (strong, nonatomic) IBOutlet SGCustomCollectionViewFlowLayout *loadCollectionViewFlowLayout;

@end

@implementation SGLoadCollectionViewController

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
    
    //Register the class.
    [self.collectionView registerClass:[SGSaveLoadItemCell class] forCellWithReuseIdentifier:@"loadGameCollectionCell"];
    
    //Setup the layout.
    [self setupTheLayout];
}

- (void)setupTheLayout{
    //Setup the flow layout.
    self.loadCollectionViewFlowLayout = [[SGCustomCollectionViewFlowLayout alloc] init];
    [self.loadCollectionViewFlowLayout setItemSize:CGSizeMake(279, 108)]; //The cell's size.
    [self.loadCollectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.loadCollectionViewFlowLayout.minimumLineSpacing = 2.0f;
    
    //Setup the collectionView.
    [self.collectionView setCollectionViewLayout:self.loadCollectionViewFlowLayout];
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"loadGameCollectionCell";
    
    SGSaveLoadItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"eden_1" ofType:@"jpg" inDirectory:@"GameData/CGs"];
    cell.saveDataScreenShotImage.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    return cell;
}

- (IBAction)exitLoadGameScreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



#pragma mark - Custom the UICollectionViewFlowLayout

@implementation SGCustomCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *theLayout = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 1; i < [theLayout count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = theLayout[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = theLayout[i - 1];
        
        NSInteger maximumSpacing = 2; //Set the cell space in the same line in vertical scrolling mode.
        
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return theLayout;
}

@end












































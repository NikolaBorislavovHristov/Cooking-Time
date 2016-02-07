//
//  RecipeDetail.m
//  Cooking Time
//
//  Created by Nikola Hristov on 6/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "NHToastService.h"
@interface RecipeDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *imageWrapper;
@property (weak, nonatomic) IBOutlet UICollectionView *ratingView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *ingredientsTable;

@end

@implementation RecipeDetailViewController {
    CGRect initImageFrame;
}

static NSString* cellIdentifire = @"RatingCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigation setTitle:self.recipe.name];
    
    self.image.image = self.recipe.smallImage;
    initImageFrame = self.image.frame;
    
    self.ratingView.dataSource = self;
    self.ratingView.delegate = self;
    
    UINib* nib = [UINib nibWithNibName:cellIdentifire
                                bundle:nil];
    
    [self.ratingView registerNib:nib
      forCellWithReuseIdentifier:cellIdentifire];

    self.timeLabel.text = [NSString stringWithFormat:@"%@ min", self.recipe.time];
}


- (IBAction)resizeImage:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.image setFrame:initImageFrame];
    } else {
        CGRect newFrame = initImageFrame;
        newFrame.size.width *= sender.scale;
        newFrame.size.height *= sender.scale;
        
        [self.image setFrame:newFrame];
    }
    
    self.image.center = CGPointMake(self.imageWrapper.frame.size.width  / 2,
                                    self.imageWrapper.frame.size.height / 2);
    
//    recipe.ingredients = ingredients;
//    recipe.flavors = flavors;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.recipe.rating intValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifire
                                                                           forIndexPath:indexPath];
    
    return cell;
}

@end

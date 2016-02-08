//
//  RecipeDetail.m
//  Cooking Time
//
//  Created by Nikola Hristov on 6/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "NHToastService.h"
#import "FlavorTableViewCell.h"
#import "NHDbContext.h"
#import "NHImageServices.h"

@interface RecipeDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *imageWrapper;
@property (weak, nonatomic) IBOutlet UICollectionView *ratingView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *ingredientsTable;
@property (weak, nonatomic) IBOutlet UITableView *flavorsTable;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@end

@implementation RecipeDetailViewController {
    CGRect initImageFrame;
    NSArray *flavorNames;
}

static NSString* ratingCellIdentifire = @"RatingCollectionViewCell";
static NSString* flavorCellIdentifire = @"FlavorTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scroller setScrollEnabled:YES];
    
    flavorNames = [self.recipe.flavors allKeys];
    [self.navigation setTitle:self.recipe.name];
    
    self.image.image = self.recipe.smallImage;
    
    initImageFrame = self.image.frame;
    
    self.ratingView.dataSource = self;
    self.ratingView.delegate = self;
    
    UINib* starNib = [UINib nibWithNibName:ratingCellIdentifire
                                    bundle:nil];
    
    [self.ratingView registerNib:starNib
      forCellWithReuseIdentifier:ratingCellIdentifire];
    
    UINib* flavorNib = [UINib nibWithNibName:flavorCellIdentifire
                                bundle:nil];
    
    [self.flavorsTable registerNib:flavorNib
            forCellReuseIdentifier:flavorCellIdentifire];

    self.timeLabel.text = [NSString stringWithFormat:@"%@ min", self.recipe.time];
    
    self.ingredientsTable.allowsSelection = NO;
    self.ingredientsTable.delegate = self;
    self.ingredientsTable.dataSource = self;
    
    self.flavorsTable.allowsSelection = NO;
    self.flavorsTable.delegate = self;
    self.flavorsTable.dataSource = self;
}

-(void) viewDidAppear:(BOOL)animated {
    CGRect newFrame = self.view.frame;
    newFrame.size.height += 100;

    self.scroller.contentSize = newFrame.size;
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
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.recipe.rating intValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ratingCellIdentifire
                                                                           forIndexPath:indexPath];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.ingredientsTable) {
        return self.recipe.ingredients.count;
    } else {
        return self.recipe.flavors.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.ingredientsTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientTableViewCell" forIndexPath:indexPath];
        
        NSString *ingredient = self.recipe.ingredients[indexPath.row];
        cell.textLabel.text = ingredient;
        cell.textLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:17];
        cell.textLabel.textColor = [UIColor colorWithRed:225.0f/255.0f
                                                   green:97.0f/255.0f
                                                    blue:32.0f/255.0f
                                                   alpha:1];
        return cell;
    } else {
        FlavorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flavorCellIdentifire forIndexPath:indexPath];
        cell.name.text = flavorNames[indexPath.row];
        cell.progressBar.progress = [[self.recipe.flavors valueForKey:flavorNames[indexPath.row]] floatValue];
        return cell;
    }
}

- (IBAction)addToList {
    [[NHDbContext context] addRecipe:self.recipe];
}

@end

//
//  BrowseResultViewController.m
//  Cooking Time
//
//  Created by Nikola Hristov on 6/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "BrowseResultViewController.h"
#import "NHRecipeServices.h"
#import "NHRecipe.h"
#import "NoInternetView.h"
#import "Cooking_Time-Swift.h"
#import "NHToastService.h"
#import "RecipeTableViewCell.h"
#import "NHImageServices.h"
#import "RecipeDetail.h"

@interface BrowseResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UITableView *recipesTableView;
@property NSMutableArray* recipes;
@property NoInternetView* noInternetView;

@end

@implementation BrowseResultViewController

static NSString* defaultImageIdentifire = @"no-image.png";
static NSString* cellIdentifire = @"RecipeTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recipesTableView.dataSource = self;
    self.recipesTableView.delegate = self;
    
    UINib* nib = [UINib nibWithNibName:cellIdentifire
                                bundle:nil];
    
    [self.recipesTableView registerNib:nib
                forCellReuseIdentifier:cellIdentifire];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.doReloading) {
        self.doReloading = NO;
        [self loadRecipes];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NHLoadingServices hide];
}

-(void) loadRecipes {
    [NHLoadingServices show:@"Loading recipes..."];
    
    [NHRecipeServices searchByCriteria: self.params
                               callback: ^(NSArray *recipes, NSString *errorMessage) {
                                   if (errorMessage) {
                                       [NHLoadingServices fail];
                                       [NHToastService showWithText:errorMessage];
                                   } else {
                                       [NHLoadingServices success];
                                       self.recipes = [NSMutableArray arrayWithArray:recipes];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [self.recipesTableView reloadData];
                                       });
                                   }
                               }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NHRecipe *currentRecipe = [self.recipes objectAtIndex:indexPath.row];
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire forIndexPath:indexPath];
    
    cell.title.text = currentRecipe.name;
    cell.image.image = [UIImage imageNamed: defaultImageIdentifire];
    [cell setRating:currentRecipe.rating];
    
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor colorWithRed:225.0f/255.0f
                                               green:225.0f/255.0f
                                                blue:225.0f/255.0f
                                               alpha:1];
        
    } else {
        cell.backgroundColor = [UIColor colorWithRed:245.0f/255.0f
                                               green:245.0f/255.0f
                                                blue:245.0f/255.0f
                                               alpha:1];
    }
    
    [NHImageServices getImage:currentRecipe.imageUrl callback:^(UIImage *image, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            RecipeTableViewCell *updateCell = (RecipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell) {
                updateCell.image.image = image;
            }
        });
    }];
    
    return cell;
}

- (IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue {
    self.doReloading = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqual:@"showDetail"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        
        NHRecipe *selectedRecipe = [self.recipes objectAtIndex:indexPath.row];
        RecipeTableViewCell *selectedCell = (RecipeTableViewCell *)[self.recipesTableView cellForRowAtIndexPath:indexPath];
        UIImage *tempImage = selectedCell.image.image;
        
        RecipeDetail *recipeDetailController = (RecipeDetail *)segue.destinationViewController;
        recipeDetailController.recipe = selectedRecipe;
        recipeDetailController.tempImage = tempImage;
    }
}
@end

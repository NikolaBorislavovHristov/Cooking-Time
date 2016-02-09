//
//  ShopingListViewController.m
//  Cooking Time
//
//  Created by Nikola Hristov on 8/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "ShopingListViewController.h"
#import "NHDbContext.h"
#import "NHRecipe.h"
#import "RecipeDetailViewController.h"
#import "RecipeTableViewCell.h"
#import "NHImageServices.h"

@interface ShopingListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *shopingList;
@property NSArray* recipes;

@end

@implementation ShopingListViewController

static NSString* defaultImageIdentifire = @"no-image.png";
static NSString* cellIdentifire = @"RecipeTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shopingList.dataSource = self;
    self.shopingList.delegate = self;
    
    UINib* nib = [UINib nibWithNibName:cellIdentifire
                                bundle:nil];
    
    [self.shopingList registerNib:nib
                forCellReuseIdentifier:cellIdentifire];
    
}

- (void) viewWillAppear:(BOOL)animated {
    self.recipes = [[NHDbContext context] getRecipes];
    [self.shopingList reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NHRecipe *currentRecipe = [self.recipes objectAtIndex:indexPath.row];
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire forIndexPath:indexPath];
    
    cell.title.text = currentRecipe.name;
    cell.image.image = [UIImage imageNamed: defaultImageIdentifire];
    
    [NHImageServices getImage:currentRecipe.imageUrl callback:^(UIImage *image, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            RecipeTableViewCell *updateCell = (RecipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell) {
                updateCell.image.image = image;
                currentRecipe.smallImage = image;
            }
        });
    }];
    
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
    
    return cell;
}

- (IBAction)unwindForSegueToShoppingList:(UIStoryboardSegue *)unwindSegue {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetailRecipe" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqual:@"showDetailRecipe"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NHRecipe *selectedRecipe = [self.recipes objectAtIndex:indexPath.row];
        RecipeDetailViewController *recipeDetailController = (RecipeDetailViewController *)segue.destinationViewController;
        recipeDetailController.recipe = selectedRecipe;
        recipeDetailController.comeFrom = @"shoppinglist";
    }
}

@end

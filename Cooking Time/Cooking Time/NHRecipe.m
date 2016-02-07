
//
//  NHRecipe.m
//  Cooking Time
//
//  Created by Nikola Hristov on 6/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NHRecipe.h"

@implementation NHRecipe

+(instancetype) initWithImageUrl: (NSString*)imageUrl
                            name: (NSString*)name
                     ingredients: (NSArray*)ingredients
                            time: (NSNumber*)time
                         flavors: (NSArray*)flavors
                        recipeId: (NSString*)recipeId
                       andRating: (NSNumber*)rating; {
    
    NHRecipe *recipe = [[NHRecipe alloc] init];
    
    recipe.imageUrl = imageUrl;
    recipe.name = name;
    recipe.ingredients = ingredients;
    recipe.time = time;
    recipe.flavors = flavors;
    recipe.rating = rating;
    recipe.recipeId = recipeId;
    
    return recipe;
}

@end

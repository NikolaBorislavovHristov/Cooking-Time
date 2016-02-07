//
//  NHRecipesServices.h
//  Cooking Time
//
//  Created by Nikola Hristov on 5/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHRecipe.h"

@interface NHRecipeServices : NSObject

+(void)searchByCriteria:(NSDictionary *)criteria
               callback:(void (^)(NSArray* recipes, NSString* errorMessage))callback;

+(void)getRecipeDetails:(NSString *)recipeId
               callback:(void (^)(NHRecipe* recipe, NSString* errorMessage))callback;

@end

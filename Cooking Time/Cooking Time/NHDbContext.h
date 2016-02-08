//
//  NHDbContext.h
//  Cooking Time
//
//  Created by Nikola Hristov on 4/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NHRecipe.h"

@interface NHDbContext : NSObject
+(instancetype) context;
-(NSArray*) getRecipes;
-(void) addRecipe: (NHRecipe*) recipe;
@end

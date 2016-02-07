//
//  NHRecipe.h
//  Cooking Time
//
//  Created by Nikola Hristov on 6/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NHRecipe : NSObject

@property (strong, nonatomic) NSString* imageUrl;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray* ingredients;
@property (strong, nonatomic) NSNumber* time;
@property (strong, nonatomic) NSDictionary* flavors;
@property (strong, nonatomic) NSNumber* rating;
@property (strong, nonatomic) NSString* recipeId;
@property (strong, nonatomic) UIImage* smallImage;

@property (strong, nonatomic) UIImage* photo;
@property (strong, nonatomic) UIImage* audio;
@property (strong, nonatomic) NSString* notes;

+(instancetype) initWithImageUrl: (NSString*)imageUrl
                            name: (NSString*)name
                     ingredients: (NSArray*)ingredients
                            time: (NSNumber*)time
                         flavors: (NSDictionary*)flavors
                        recipeId: (NSString*)recipeId
                       andRating: (NSNumber*)rating;

@end
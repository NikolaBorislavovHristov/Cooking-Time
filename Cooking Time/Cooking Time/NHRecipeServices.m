//
//  NHRecipesServices.m
//  Cooking Time
//
//  Created by Nikola Hristov on 5/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NHRecipeServices.h"
#import "NHHttpClient.h"

@implementation NHRecipeServices

+(void)searchByCriteria:(NSDictionary *)criteria
               callback:(void (^)(NSArray* recipes, NSString* errorMessage))callback;{
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://api.yummly.com/v1/api/recipes"];
    NSMutableArray *queryItems = [NSMutableArray array];
    
    NSString *q = [[criteria valueForKey:@"phrase"] stringByReplacingOccurrencesOfString:@" "
                                                                              withString:@"+" ];
    NSString *requirePictures = [[criteria valueForKey:@"requirePicture"] intValue] == 1 ? @"true" : @"false";
    NSString *maxTotalTimeInSeconds = [[NSNumber numberWithInt:[criteria[@"duration"] intValue] * 60] stringValue];
    NSArray *ingredients = criteria[@"ingredients"];

    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"_app_id" value:@"d65eb714"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"_app_key" value:@"4ca7c223bdca8a2232bbbaebfe24cddc"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"q" value:q]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"requirePictures" value:requirePictures]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxTotalTimeInSeconds" value:maxTotalTimeInSeconds]];
    
    for (NSString* ingredient in ingredients) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"allowedIngredient[]" value:ingredient]];
    }
    
    components.queryItems = queryItems;
    
    NSString* endPoint = [components.URL absoluteString];
    
    NHHttpClient *client = [NHHttpClient withEndpointURL:endPoint];
    NSString *fakeresponse = @"{\"criteria\":{\"q\":\"onion soup\",\"allowedIngredient\":[\"cognac\",\"garlic\"],\"excludedIngredient\":null},\"matches\":[{\"imageUrlsBySize\":{\"90\":\"http://lh3.googleusercontent.com/kKVZxUbjmMjvDvu40iDMAsq4z6gBxnmXdoQy396h18CL7pf8XQ1tov4g4SK7j7V2AGJ3X9vGOXCX2BGUZed9=s90-c\"},\"sourceDisplayName\":\"Analida's Ethnic Spoon\",\"ingredients\":[\"onions\",\"butter\",\"sugar\",\"flour\",\"black pepper\",\"kosher salt\",\"beef stock\",\"garlic cloves\",\"dry red wine\",\"thyme\",\"oregano\",\"bay leaves\",\"cognac\",\"nutmeg\",\"gruyere cheese\",\"toasted baguette\"],\"id\":\"French-Onion-Soup-1083017\",\"smallImageUrls\":[\"http://lh3.googleusercontent.com/gJerK5OCZdxD_i6YkvNwzqNINu5kj-ZaUAchmUbrzbb5n-9F7EQTenhNndk3uXPY2adOJlHzjWpXLyRCZUq-BQ=s90\"],\"recipeName\":\"French Onion Soup\",\"totalTimeInSeconds\":6300,\"attributes\":{\"course\":[\"Soups\"],\"cuisine\":[\"French\"]},\"flavors\":{\"piquant\":0.0,\"meaty\":0.16666666666666666,\"bitter\":0.16666666666666666,\"sweet\":0.16666666666666666,\"sour\":0.16666666666666666,\"salty\":0.6666666666666666},\"rating\":4},{\"imageUrlsBySize\":{\"90\":\"http://lh3.googleusercontent.com/WEjQ1LHTA4pjhqBiYDWhvBqfQ2P7j3_NPT-pwEGrQ8UtE3NANa0zIxJJg2sK7cndrPBL5s6fU5wzF3aKJTFhng=s90-c\"},\"sourceDisplayName\":\"Rants Raves and Recipes\",\"ingredients\":[\"yellow onion\",\"butter\",\"oil\",\"sugar\",\"salt\",\"all-purpose flour\",\"beef stock\",\"vermouth\",\"pepper\",\"cognac\",\"baguette\",\"garlic\",\"grating cheese\"],\"id\":\"Onion-Soup-1094122\",\"smallImageUrls\":[\"http://lh3.googleusercontent.com/SV_CrlPeSABixS4KmHRJdK8vvpWnTKvh97HOPJna6eAq6_D9uD6U0-T43ktfYx_QboYtV5UmJGQdEr7hF5V0=s90\"],\"recipeName\":\"Onion Soup\",\"totalTimeInSeconds\":4800,\"attributes\":{\"course\":[\"Soups\"]},\"flavors\":null,\"rating\":4},{\"imageUrlsBySize\":{\"90\":\"http://lh3.googleusercontent.com/HGzVJ6KSP5CVxkB_or245dB-FcKcnJT4ahh55xlYAsaHKlHwhxOWKTSJmgJR1_-tAMOHIGfMAe2VCBoSiZ0fZw=s90-c\"},\"sourceDisplayName\":\"aprilcook.me\",\"ingredients\":[\"onions\",\"garlic\",\"oil\",\"white wine\",\"cognac\",\"flour\",\"beef stock\",\"salt\",\"pepper\",\"day old bread\",\"cheese\"],\"id\":\"Onion-Soup-Gratin-1213341\",\"smallImageUrls\":[\"http://lh3.googleusercontent.com/bORF87Mhjmvljtqy-uJt4Z1z4MnNodzl5JYeS3_IZDvCbU_LqBSv3DzVDeHb9TMhIDLJ_XmzMJRI28RxFdk17g=s90\"],\"recipeName\":\"Onion Soup Gratin\",\"totalTimeInSeconds\":4500,\"attributes\":{\"course\":[\"Soups\"]},\"flavors\":{\"piquant\":0.0,\"meaty\":0.16666666666666666,\"bitter\":0.16666666666666666,\"sweet\":0.16666666666666666,\"sour\":0.16666666666666666,\"salty\":0.16666666666666666},\"rating\":4},{\"imageUrlsBySize\":{\"90\":\"http://lh5.ggpht.com/RTgD70gTiBm-C-BUjisc0H4TDfOvt5GSKzt7HOfNi7LjrKO3G5rtRRbPpVhSJF75QdBKzM_gd9CnDCEuD9qGjSQ=s90-c\"},\"sourceDisplayName\":\"Epicurious\",\"ingredients\":[\"butter\",\"onions\",\"thyme sprigs\",\"portabello mushroom\",\"cognac\",\"garlic cloves\",\"vegetable broth\",\"dry white wine\",\"baguette\",\"soft fresh goat cheese\"],\"id\":\"Caramelized-Onion-And-Portobello-Mushroom-Soup-With-Goat-Cheese-Croutons-Epicurious\",\"smallImageUrls\":[\"http://lh5.ggpht.com/eXOeuvbNStQJyNcJPSdGF8-UsxD-JkDk6Bu1_viuaGr-3UvcpNnitilw3v0x3JyETQQlU4TIpUFEQ-J8fqT-lA=s90\"],\"recipeName\":\"Caramelized Onion and Portobello Mushroom Soup with Goat Cheese Croutons\",\"totalTimeInSeconds\":5400,\"attributes\":{\"course\":[\"Soups\"]},\"flavors\":{\"sweet\":0.8333333333333334,\"salty\":1.0,\"bitter\":1.0,\"sour\":1.0,\"meaty\":1.0,\"piquant\":0.0},\"rating\":5},{\"imageUrlsBySize\":{\"90\":\"https://lh3.googleusercontent.com/JZ29ykIqTHO7uKaieYtmgcp-zMK2f8xQN5BFmmDu_2c9XmmWHvfb9Kr_coI1TCxU4PotFWMZSQhHKGhXJT49=s90-c\"},\"sourceDisplayName\":\"Cooking On The Ranch.\",\"ingredients\":[\"cooking spray\",\"butter\",\"onions\",\"garlic\",\"dried basil\",\"honey\",\"clove\",\"tomatoes\",\"orange\",\"salt\",\"pepper\",\"heavy whipping cream\",\"cognac\",\"sour cream\",\"crème fraîche\",\"basil leaves\"],\"id\":\"Tomato-Soup-with-Cognac-and-Orange-1319012\",\"smallImageUrls\":[\"http://lh3.googleusercontent.com/Cob3ZGAKq5nHxFJR3M76e0QtS9_1R4ZOufcOrffo9m5hA99unUvV5y60H9lsHIIZG5rUHvqt3brokORRmuwl=s90\"],\"recipeName\":\"Tomato Soup with Cognac and Orange\",\"totalTimeInSeconds\":3900,\"attributes\":{\"course\":[\"Soups\"]},\"flavors\":null,\"rating\":4},{\"imageUrlsBySize\":{\"90\":\"http://lh4.ggpht.com/7tQjC-eT6Em-7UWWxrYww8GqiEQeRqdFT1Fz1bfyZ5gIZNNYhUmI4Ek5iCm4RO0-WpjsJjIgwYEEs2N2vOt6=s90-c\"},\"sourceDisplayName\":\"Recetas del Señor Señor\",\"ingredients\":[\"vegetable oil\",\"leeks\",\"onions\",\"carrots\",\"celery ribs\",\"garlic cloves\",\"cognac\",\"tomato purée\",\"large shrimp\",\"fish stock\",\"salt\",\"sour cream\",\"mixed nuts\",\"egg whites\"],\"id\":\"Cream-of-Shrimp-Soup-531526\",\"smallImageUrls\":[\"http://lh3.ggpht.com/lKTPggLOjgbw9MpMLHp1JpeDczoXvTEtxuvOMk325AvLe8dNBhKyFr8Dg2hoNs1hj-Gci1aP4e33tFV2QoHRbns=s90\"],\"recipeName\":\"Cream of Shrimp Soup\",\"totalTimeInSeconds\":4200,\"attributes\":{\"course\":[\"Lunch and Snacks\",\"Soups\"]},\"flavors\":{\"bitter\":0.5,\"meaty\":0.16666666666666666,\"piquant\":0.0,\"salty\":0.5,\"sour\":0.5,\"sweet\":0.5},\"rating\":4},{\"imageUrlsBySize\":{\"90\":\"http://lh3.googleusercontent.com/ip5Pz0Ydijo9RXR5y_zqelAOpIIjesSgaVXKWIEYuXdLLHA4ysDerEosZonFB7XdjkHZd1usqyMqGm2UlD55QA=s90-c\"},\"sourceDisplayName\":\"Manger\",\"ingredients\":[\"beets\",\"butter\",\"onions\",\"shallots\",\"leeks\",\"carrots\",\"celery\",\"beef stock\",\"potatoes\",\"cabbage\",\"garlic\",\"allspice\",\"bay leaf\",\"cider vinegar\",\"pepper\",\"salt\",\"crème fraîche\",\"fresh dill\",\"buckwheat flour\",\"plain flour\",\"clarified butter\",\"eggs\",\"baking powder\",\"whole milk\",\"unsalted butter\",\"steak\",\"button mushrooms\",\"cognac\",\"paprika\",\"mustard\",\"olive oil\",\"parsley\"],\"id\":\"Borscht-Soup-966809\",\"smallImageUrls\":[\"http://lh3.googleusercontent.com/K4TFJzdhJA1-gYTTv3w7zDhe62ZhPH_Q7IB--6tMAsgt2IMNyOIthAEJyidrw3Qbs6cOF0g0W7JTGlLzxkSv=s90\"],\"recipeName\":\"Borscht Soup\",\"totalTimeInSeconds\":4800,\"attributes\":{\"course\":[\"Soups\"]},\"flavors\":{\"piquant\":0.16666666666666666,\"meaty\":0.16666666666666666,\"bitter\":0.3333333333333333,\"sweet\":0.16666666666666666,\"sour\":0.5,\"salty\":0.3333333333333333},\"rating\":4},{\"imageUrlsBySize\":{\"90\":\"http://lh5.ggpht.com/P_o11uiH5syaWcvqPHBZSXUXuDCbpLFDboLBx8_y29xFnKPno6fjwDNzJE5UsngLt1gS8LFe2C8Rf-WpYhR9lg=s90-c\"},\"sourceDisplayName\":\"How Sweet It Is\",\"ingredients\":[\"deveined shrimp\",\"olive oil\",\"leeks\",\"salt\",\"pepper\",\"garlic cloves\",\"crushed red pepper flakes\",\"cognac\",\"dry sherry\",\"unsalted butter\",\"flour\",\"seafood\",\"half & half\",\"heavy cream\",\"tomato paste\",\"asiago\",\"herbs\",\"bread\"],\"id\":\"Asiago-shrimp-bisque-333285\",\"smallImageUrls\":[\"http://lh6.ggpht.com/mtVbnIdWsU8LUoT74Njp-cnM1cK7vIM8JQbZiH6FH5aSaVsL0dnYBofFZLIS_JohadQlw0Sq2BaKyn1OYD_biA=s90\"],\"recipeName\":\"Asiago Shrimp Bisque\",\"totalTimeInSeconds\":3600,\"attributes\":{\"course\":[\"Soups\"]},\"flavors\":{\"bitter\":0.6666666666666666,\"meaty\":0.5,\"piquant\":0.0,\"salty\":0.6666666666666666,\"sour\":0.6666666666666666,\"sweet\":0.5},\"rating\":5},{\"imageUrlsBySize\":{\"90\":\"http://lh4.ggpht.com/wClUePBMRn8qKGIFOtEdK2D5AJ3d0CARU3hSqVOgS5VeVfNLPYSldin5mEA1D9xAaGOgAfy9J4Ouiwi6nCdb=s90-c\"},\"sourceDisplayName\":\"Food52\",\"ingredients\":[\"leeks\",\"shallots\",\"celery\",\"shiitake\",\"mushrooms\",\"bacon\",\"cognac\",\"beef\",\"quinoa\",\"diced tomatoes\",\"marjoram\",\"peppercorns\",\"salt\",\"pepper\",\"garlic\",\"fresh thyme\",\"chopped parsley\",\"grated parmesan cheese\"],\"id\":\"3-mushroom-soup-with-sherry-and-marjoram-315925\",\"smallImageUrls\":[\"http://lh6.ggpht.com/4GqF_ui8_bqi_PSq2xKxslrln4k58QvZ5cGW7JiiDfN3vH-m9F88Sdq-Nr5OxdjQseNwPbc7Grpd7S_d4HKwPA=s90\"],\"recipeName\":\"3 Mushroom Soup with Sherry and Marjoram\",\"totalTimeInSeconds\":3300,\"attributes\":{\"course\":[\"Soups\"]},\"flavors\":{\"piquant\":0.16666666666666666,\"meaty\":0.5,\"bitter\":0.3333333333333333,\"sweet\":0.16666666666666666,\"sour\":0.16666666666666666,\"salty\":0.16666666666666666},\"rating\":3},{\"imageUrlsBySize\":{\"90\":\"http://lh3.googleusercontent.com/yhcmcL8-OvmT3JsncVOO9D5bfzo3QST5TLaGoulniaJE98Y50ufSEOYyb-glUTD7reLrVlO4Qj32BWuqN7sYz1E=s90-c\"},\"sourceDisplayName\":\"The Galley Gourmet\",\"ingredients\":[\"shrimp\",\"chicken broth\",\"unsalted butter\",\"leeks\",\"shallots\",\"garlic\",\"cognac\",\"dry sherry\",\"unbleached all-purpose flour\",\"half & half\",\"tomato paste\",\"kosher salt\",\"ground black pepper\",\"cayenne pepper\",\"chives\"],\"id\":\"Shrimp-Bisque-1283944\",\"smallImageUrls\":[\"http://lh3.googleusercontent.com/TX8Kl3OzQn-VdgV2mUppdZ01HhEHKOIDxIVy1OA1UZbe5oaKn5KrWheoT7fcXOcoAdHt3oekW5BoM3M0CXoHDg=s90\"],\"recipeName\":\"Shrimp Bisque\",\"totalTimeInSeconds\":3600,\"attributes\":{\"course\":[\"Soups\"]},\"flavors\":{\"piquant\":0.8333333333333334,\"meaty\":0.16666666666666666,\"bitter\":0.16666666666666666,\"sweet\":0.16666666666666666,\"sour\":0.16666666666666666,\"salty\":0.3333333333333333},\"rating\":4}],\"facetCounts\":{},\"totalMatchCount\":75,\"attribution\":{\"html\":\"Recipe search powered by <a href='http://www.yummly.com/recipes'><img alt='Yummly' src='http://static.yummly.com/api-logo.png'/></a>\",\"url\":\"http://www.yummly.com/recipes/\",\"text\":\"Recipe search powered by Yummly\",\"logo\":\"http://static.yummly.com/api-logo.png\"}}";
    
    
    
    NSData *data = [fakeresponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
            NSArray* recipesRawData = [resp valueForKey:@"matches"];
            NSMutableArray* recipes = [NSMutableArray array];
    
            for (int i = 0; i < recipesRawData.count; i++) {
                NSDictionary *currentRecipeRawData = [recipesRawData objectAtIndex:i];
    
                NSString *recipeId = [currentRecipeRawData valueForKey:@"id"];
                NSString *imageUrl = [[currentRecipeRawData valueForKey:@"imageUrlsBySize"]
                                      valueForKey:@"90"];
    
                NSString *name = [currentRecipeRawData valueForKey:@"recipeName"];
    
                NSArray *ingredients = [currentRecipeRawData valueForKey:@"ingredients"];
                NSNumber *time = [NSNumber numberWithInt:([[currentRecipeRawData valueForKey:@"totalTimeInSeconds"] intValue] / 60)];
                NSDictionary *flavors = [currentRecipeRawData valueForKey:@"flavors"];
                NSNumber *rating = [currentRecipeRawData valueForKey:@"rating"];
    
                NHRecipe *currentRecipe = [NHRecipe initWithImageUrl:imageUrl
                                                                name:name
                                                         ingredients:ingredients
                                                                time:time
                                                             flavors:flavors
                                                             recipeId:recipeId
                                                           andRating:rating];
                [recipes addObject:currentRecipe];
            }
    
    callback(recipes, nil);
}


+(void)getRecipeDetails:(NSString *)recipeId
               callback:(void (^)(NHRecipe* recipe, NSString* errorMessage))callback; {
    
}

@end
//    [client send:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            callback(nil, @"Can't connect with Ymmly.");
//            return;
//        }
//        
//        NSError* jsonError;
//        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data
//                                                             options:NSJSONReadingAllowFragments
//                                                               error:&jsonError];
//        if (jsonError) {
//            callback(nil, @"Invalid response from server");
//            return;
//        }
//        
//        
//        NSDictionary * err = [resp valueForKey:@"error"];
//        if (err) {
//            NSString* errorMessage = [err valueForKey:@"message"];
//            callback(nil, errorMessage);
//            return;
//        }
//        
//        NSArray* recipesRawData = [resp valueForKey:@"matches"];
//        NSMutableArray* recipes = [NSMutableArray array];
//        
//        for (int i = 0; i < recipesRawData.count; i++) {
//            NSDictionary *currentRecipeRawData = [recipesRawData objectAtIndex:i];
//            
//            NSString *imageUrl = [[currentRecipeRawData valueForKey:@"imageUrlsBySize"]
//                                  valueForKey:@"90"];
//            
//            NSString *name = [currentRecipeRawData valueForKey:@"recipeName"];
//            
//            NSArray *ingredients = [currentRecipeRawData valueForKey:@"ingredients"];
//            NSNumber *time = [NSNumber numberWithInt:([[currentRecipeRawData valueForKey:@"totalTimeInSeconds"] intValue] / 60)];
//            NSArray *flavors = [currentRecipeRawData valueForKey:@"flavors"];
//            NSNumber *rating = [currentRecipeRawData valueForKey:@"rating"];
//            
//            NHRecipe *currentRecipe = [NHRecipe initWithImageUrl:imageUrl
//                                                            name:name
//                                                     ingredients:ingredients
//                                                            time:time
//                                                         flavors:flavors
//                                                       andRating:rating];
//            [recipes addObject:currentRecipe];
//        }
//        
//        callback(recipes, nil);
//    }];


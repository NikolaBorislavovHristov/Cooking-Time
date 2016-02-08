//
//  NHDbContext.m
//  Cooking Time
//
//  Created by Nikola Hristov on 4/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NHDbContext.h"
#import "NHToastService.h"
#import "NHRecipe.h"
#import "NHImageServices.h"
#import "NHRecipeServices.h"

@implementation NHDbContext {
    sqlite3 *_db;
}

-(instancetype)init {
    if(self = [super init]) {
        NSString *sqliteDb = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"db"];
        if(sqlite3_open([sqliteDb UTF8String], &_db)) {
            [NHToastService showWithText:@"Can't open database"];
        }
    }
    
    return self;
}

-(void)dealloc {
    if(_db != nil) {
        sqlite3_close(_db);
    }
}

+(instancetype) context {
    static NHDbContext *databaseInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        databaseInstance = [[NHDbContext alloc] init];
    });
    
    return databaseInstance;
}

-(NSArray*) getRecipes {
    NSMutableArray *result = [NSMutableArray array];
    NSString *query = @"SELECT * FROM Recipes";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare(_db, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while(sqlite3_step(statement) == SQLITE_ROW) {
            
            int recipeIdRaw =(int)sqlite3_column_int(statement, 0);
            NSNumber *recipeId = [NSNumber numberWithInt:recipeIdRaw];
            
            int length = sqlite3_column_bytes(statement, 1);
            NSData *rawData = [[NSData alloc] initWithBytes: sqlite3_column_blob(statement, 1) length: length];
            
            NSString* rawStr = [[[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            
            NSDictionary *recipeRawData = [NHDbContext convertStringToDictionary:rawStr];
                           
            NHRecipe *recipe = [NHRecipeServices convertJsonToRecipes:recipeRawData];
            [result addObject:recipe];
        }
    }
    
    return result;
}

-(void) addRecipe: (NHRecipe*) recipe {
    
    NSString *blob = [[NHDbContext convertDictionaryToString:recipe.rawData] stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    NSString *query = [NSString stringWithFormat:@"INSERT INTO Recipes (value) VALUES (\"%@\")", blob];
    sqlite3_stmt *statement;
    
    sqlite3_prepare_v2(_db, [query UTF8String], -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)  {
        [NHToastService showWithText:@"Recipe added to shopping list"];
    }
    else {
        [NHToastService showWithText:@"Recipe not added to shopping list"];
    }
    
    sqlite3_finalize(statement);
}

+(NSString *) convertDictionaryToString: (NSDictionary*) dict {
    NSData * dictToData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:0
                                                            error:nil];
    
    return [[NSString alloc] initWithData:dictToData
                                 encoding:NSUTF8StringEncoding];
}

+(NSDictionary*) convertStringToDictionary: (NSString*) str {
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    
    return (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers
                                                             error:nil];
}

@end

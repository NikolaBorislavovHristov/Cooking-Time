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

@implementation NHDbContext {
    sqlite3 *_db;
}

-(instancetype)init {
    if(self = [super init]) {
        NSString *sqliteDb = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"sqlite"];
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
    NSString *query = @"SELECT name FROM Superheroes";
    sqlite3_stmt *statement;
    if(sqlite3_prepare(_db, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while(sqlite3_step(statement) == SQLITE_ROW) {
            //one more row in the result (statement)
            char* nameChars =(char*) sqlite3_column_text(statement, 0);
            
            NSString *name = [NSString stringWithUTF8String:nameChars];
            
//            Superhero *superhero = [Superhero superheroWithName:name];
            
//            [result addObject:superhero];
        }
    }
    
    return result;
}

-(void) addRecipe: (NHRecipe*) recipe {
//    NSString *query = [NSString stringWithFormat:@"INSERT INTO Recipes (name) VALUES (\"%@\")", superhero.name];
    
    sqlite3_stmt *statement;
    
    char* errMsg;
    
//    sqlite3_prepare_v2(_db, [query UTF8String], -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        NSLog(@"Ok!");
    }
    else {
        NSLog(@"Not Ok!");
        NSLog(@"%@", [NSString stringWithUTF8String:errMsg]);
    }
    sqlite3_finalize(statement);
}

@end

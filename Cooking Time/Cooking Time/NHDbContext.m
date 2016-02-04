//
//  NHDbContext.m
//  Cooking Time
//
//  Created by Nikola Hristov on 4/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NHDbContext.h"

@implementation NHDbContext {
    sqlite3 *_db;
}

-(instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

+(instancetype) database {
    static NHDbContext *db;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        db = [[NHDbContext alloc] init];
    });
    
    return db;
}

-(NSArray*) getAllRecipes {
    return [NSArray array];
}


@end

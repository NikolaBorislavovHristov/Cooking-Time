//
//  HttpData.h
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHHttpClient : NSObject

@property NSString* endpointURL;

+(NHHttpClient*) withEndpointURL:(NSString*)endpointURL;

-(void) send: (void (^)(NSArray* videos, NSString* error))callback;

@end
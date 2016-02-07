//
//  HttpData.h
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHHttpClient : NSObject

+(instancetype) withEndpointURL: (NSString*)endpointURL;

-(void) send: (void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))callback;

@end
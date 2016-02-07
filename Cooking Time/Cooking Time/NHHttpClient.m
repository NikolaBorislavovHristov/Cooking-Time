//
//  HttpData.m
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NHHttpClient.h"
@interface NHHttpClient ()

@property NSString* endpointURL;

@end

@implementation NHHttpClient

+(instancetype) withEndpointURL:(NSString*)endpointURL; {
    NHHttpClient *req = [[NHHttpClient alloc] init];
    req.endpointURL = endpointURL;
    return req;
}

-(void) send: (void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))callback;{
    NSURL* url = [NSURL URLWithString:self.endpointURL];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:callback]
     resume];
}
@end

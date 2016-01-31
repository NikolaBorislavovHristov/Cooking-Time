//
//  HttpData.m
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NHHttpClient.h"

@implementation NHHttpClient

+(NHHttpClient*) withEndpointURL:(NSString*)endpointURL; {
    NHHttpClient *req = [[NHHttpClient alloc] init];
    req.endpointURL = endpointURL;
    return req;
}

-(void) send: (void (^)(NSDictionary* dict))callback; {
    NSURL* url = [NSURL URLWithString:self.baseURL];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        NSError* jsonError;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&jsonError];
        if (jsonError) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(dict);
        });
    }]
     resume];

}
@end

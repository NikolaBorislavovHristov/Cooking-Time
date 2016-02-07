//
//  ImageServices.m
//  Cooking Time
//
//  Created by Nikola Hristov on 6/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NHImageServices.h"
#import "NHHttpClient.h"

@implementation NHImageServices

+(void)getImage:(NSString *)imageURL
            callback:(void (^)(UIImage* image, NSString* errorMessage))callback; {
    
    NHHttpClient *client = [NHHttpClient withEndpointURL:imageURL];
    
    [client send:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                callback(image, nil);
                return;
            }
        }
        
        callback(nil, @"Image not found!");
    }];
}

@end

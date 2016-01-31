//
//  VideosServices.m
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NHVideosServices.h"
#import "NHHttpClient.h"
#import "NHVideo.h"

@implementation NHVideosServices

+(void)getNewestVideos: (void (^)(NSArray* videos, NSString* errorMessage))callback;{
    NSString* endPoint = @"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=20&playlistId=PL8PM5J5RodlalW_XqjytpHnDx7AHh2IFT&fields=items%2Fsnippet&key=AIzaSyBBQyjFRp5FFKb5hbTrHYhi7vHNbuYm_yY";
    
    NHHttpClient *client = [NHHttpClient withEndpointURL:endPoint];
    
    [client send:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            callback(nil, @"Can't connect with YouTube.");
            return;
        }
        
        NSError* jsonError;
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:&jsonError];
        if (jsonError) {
            callback(nil, @"Invalid response from server");
            return;
        }
        
        NSDictionary * err = [resp valueForKey:@"error"];
        if (err) {
            NSString* errorMessage = [err valueForKey:@"message"];
            callback(nil, errorMessage);
            return;
        }
        
        NSArray* videosRawData = [resp valueForKey:@"items"];
        NSMutableArray* videos = [NSMutableArray array];
        
        for (int i = 0; i < videosRawData.count; i++) {
            NSDictionary *currentVideoSnippet = [[videosRawData objectAtIndex:i]
                                                 valueForKey:@"snippet"];
            
            NSString *title = [currentVideoSnippet valueForKey:@"title"];
            
            NSString *imageURL = [[[currentVideoSnippet
                                    valueForKey:@"thumbnails"]
                                    valueForKey:@"medium"]
                                    valueForKey:@"url"];
            
            NSString *url = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", [[currentVideoSnippet valueForKey:@"resourceId"]
                                                                                               valueForKey:@"videoId"]];
            
            NHVideo *currentVideo = [NHVideo initWithImageUrl:imageURL videoURL:url andTitle:title];
            [videos addObject:currentVideo];
        }
        
        callback(videos, nil);
    }];
}

+(void)getVideoImage:(NSString *)imageURL
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

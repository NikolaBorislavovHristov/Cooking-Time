//
//  Video.m
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NHVideo.h"

@implementation NHVideo

+(NHVideo*) withImageUrl: (NSString*)imageUrl
              videoURL: (NSString*)videoURL
              andTitle: (NSString*)title;{
    
    NHVideo *video = [[NHVideo alloc] init];
    
    video.imageURL = imageUrl;
    video.videoURL = videoURL;
    video.title = title;
    
    return video;
}

@end

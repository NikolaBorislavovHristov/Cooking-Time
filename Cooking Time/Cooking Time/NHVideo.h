//
//  Video.h
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHVideo : NSObject

@property (strong, nonatomic) NSString* imageUrl;
@property (strong, nonatomic) NSString* videoURL;
@property (strong, nonatomic) NSString* title;

+(instancetype) initWithImageUrl: (NSString*)imageUrl
              videoURL: (NSString*)videoURL
              andTitle: (NSString*)title;

@end

//
//  VideosServices.h
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NHVideoServices : NSObject

+(void)getNewestVideos:(void (^)(NSArray* videos, NSString* errorMessage))callback;

@end

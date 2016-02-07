//
//  ImageServices.h
//  Cooking Time
//
//  Created by Nikola Hristov on 6/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NHImageServices : NSObject

+(void)getImage:(NSString *)imageURL
       callback:(void (^)(UIImage* image, NSString* errorMessage))callback;

+ (NSString *)imageToNSString:(UIImage *)image;

+ (UIImage *)stringToUIImage:(NSString *)string;

@end

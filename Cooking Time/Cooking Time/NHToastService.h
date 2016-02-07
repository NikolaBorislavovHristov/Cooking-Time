//
//  Toast.h
//  Cooking Time
//
//  Created by Nikola Hristov on 4/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSToastView.h"

@interface NHToastService : NSObject

+(void) showWithText:(NSString*)text;

@end

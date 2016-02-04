//
//  Toast.m
//  Cooking Time
//
//  Created by Nikola Hristov on 4/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "Toast.h"

@implementation Toast
+(void) showWithText:(NSString*)text;{
    [KSToastView ks_showToast:text duration:1.5f];
}
@end

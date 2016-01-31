//
//  VideoCell.m
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "VideoCell.h"
@implementation VideoCell

- (IBAction)goToYouTube {
    NSURL *url = [NSURL URLWithString:self.videoURL];
    [[UIApplication sharedApplication] openURL:url];
}
@end

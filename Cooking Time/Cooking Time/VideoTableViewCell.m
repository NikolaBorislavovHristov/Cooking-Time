//
//  VideoCell.m
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "VideoTableViewCell.h"
@implementation VideoTableViewCell

- (IBAction)goToYouTube {
    NSURL *url = [NSURL URLWithString:self.videoURL];
    [[UIApplication sharedApplication] openURL:url];
}

@end

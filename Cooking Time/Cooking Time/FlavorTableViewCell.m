//
//  FlavorTableViewCell.m
//  Cooking Time
//
//  Created by Nikola Hristov on 7/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "FlavorTableViewCell.h"

@implementation FlavorTableViewCell

- (void)awakeFromNib {
    self.progressBar.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:17];
    self.progressBar.popUpViewAnimatedColors = @[[UIColor colorWithRed:225.0f/255.0f
                                                                 green:97.0f/255.0f
                                                                  blue:32.0f/255.0f
                                                                 alpha:1]];
    self.progressBar.popUpViewCornerRadius = 16.0;
    [self.progressBar showPopUpViewAnimated:YES];
}

@end

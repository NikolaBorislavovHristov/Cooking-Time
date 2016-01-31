//
//  VideoCell.h
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UITextView *cellLabel;

@end

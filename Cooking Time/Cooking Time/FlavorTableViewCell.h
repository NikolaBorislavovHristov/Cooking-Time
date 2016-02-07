//
//  FlavorTableViewCell.h
//  Cooking Time
//
//  Created by Nikola Hristov on 7/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASProgressPopUpView.h"

@interface FlavorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

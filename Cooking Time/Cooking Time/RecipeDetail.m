//
//  RecipeDetail.m
//  Cooking Time
//
//  Created by Nikola Hristov on 6/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "RecipeDetail.h"
#import "NHToastService.h"
@interface RecipeDetail ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navigation;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *imageWrapper;

@end

@implementation RecipeDetail {
    CGRect initImageFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    initImageFrame = self.image.frame;
    [self.navigation setTitle:self.recipe.name];
    self.image.image = self.tempImage;
}

- (IBAction)resizeImage:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.image setFrame:initImageFrame];
    } else {
        CGRect newFrame = initImageFrame;
        newFrame.size.width *= sender.scale;
        newFrame.size.height *= sender.scale;
        
        [self.image setFrame:newFrame];
    }
    
    self.image.center = CGPointMake(self.imageWrapper.frame.size.width  / 2,
                                    self.imageWrapper.frame.size.height / 2);
}


@end

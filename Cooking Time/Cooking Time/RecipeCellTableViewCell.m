//
//  RecipeCellTableViewCell.m
//  Cooking Time
//
//  Created by Nikola Hristov on 6/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "RecipeCellTableViewCell.h"
#import "RatingCollectionViewCell.h"


@interface RecipeCellTableViewCell()  <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *ratingView;
@end

@implementation RecipeCellTableViewCell

static NSString* cellIdentifire = @"RatingCollectionViewCell";

-(void) awakeFromNib {
    [super awakeFromNib];

    self.ratingView.dataSource = self;
    self.ratingView.delegate = self;
    
    UINib* nib = [UINib nibWithNibName:cellIdentifire
                                bundle:nil];
    
    [self.ratingView registerNib:nib
      forCellWithReuseIdentifier:cellIdentifire];
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.rating intValue];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifire
                                                                         forIndexPath:indexPath];
    
    return cell;
}

-(void) setRating:(NSNumber *)rating {
    _rating = rating;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ratingView reloadData];
    });
}
@end

//
//  HomeViewController.m
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "HomeViewController.h"
#import "NHVideosServices.h"
#import "VideoCell.h"
#import "NHVideo.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *videosTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *topBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *bottomBar;
@property NSMutableArray* videos;

@end


@implementation HomeViewController

NSMutableArray *videos;

static NSString* cellIdentifire = @"VideoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videosTableView.dataSource = self;
    self.videosTableView.delegate = self;
    
    UINib* nib = [UINib nibWithNibName:cellIdentifire
                                bundle:nil];

    [self.videosTableView registerNib:nib
               forCellReuseIdentifier:cellIdentifire];
    
    
    [self loadVideos];
}

-(void) loadVideos{
    [NHVideosServices getNewestVideos:^(NSArray *videos, NSString *errorMessage) {
        if (errorMessage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.videosTableView removeFromSuperview];
                UIView *noInternetView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"NoInternetView"
                                                                        owner:self
                                                                      options:nil]
                                          objectAtIndex:0];
                
                [self.view addSubview:noInternetView];
                
                                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:noInternetView
                                                                                      attribute:NSLayoutAttributeRight
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.view
                                                                                      attribute:NSLayoutAttributeRight
                                                                                     multiplier:1
                                                                                       constant:1]];
                                [self.view updateConstraints];
                
            });
        } else {
            self.videos = [NSMutableArray arrayWithArray:videos];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.videosTableView reloadData];
            });
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NHVideo *currentVideo = [self.videos objectAtIndex:indexPath.row];
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire forIndexPath:indexPath];
    
    cell.cellImage.image = nil; // or cell.poster.image = [UIImage imageNamed:@"placeholder.png"];
    cell.cellLabel.text = currentVideo.title;
    cell.videoURL = currentVideo.videoURL;
    [NHVideosServices getVideoImage:currentVideo.imageUrl callback:^(UIImage *image, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoCell *updateCell = (VideoCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell) {
                updateCell.cellImage.image = image;
            }
        });
    }];
    
    return cell;
}

@end

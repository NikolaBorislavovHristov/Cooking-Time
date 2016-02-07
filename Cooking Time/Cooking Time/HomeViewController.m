//
//  HomeViewController.m
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NHVideosServices.h"
#import "VideoCell.h"
#import "NHVideo.h"
#import "NoInternetView.h"
#import "Cooking_Time-Swift.h"
#import "HomeViewController.h"
#import "Reachability.h"
#import "Toast.h"
#import "ImageServices.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *videosTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *topBar;
@property NSMutableArray* videos;
@property NoInternetView* noInternetView;
@property BOOL isLoading;

@end

@implementation HomeViewController

static NSString* cellIdentifire = @"VideoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoading = NO;
    self.videosTableView.allowsSelection = NO;
    self.videosTableView.dataSource = self;
    self.videosTableView.delegate = self;
    
    UINib* nib = [UINib nibWithNibName:cellIdentifire
                                bundle:nil];
    
    [self.videosTableView registerNib:nib
               forCellReuseIdentifier:cellIdentifire];
    
    self.noInternetView = (NoInternetView *)[[[NSBundle mainBundle] loadNibNamed:@"NoInternetView"
                                                                           owner:self
                                                                         options:nil]
                                             objectAtIndex:0];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self.videosTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadVideos) forControlEvents:UIControlEventValueChanged];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isLoading == YES) {
        [LoadingServices show];
    } else {
        [self loadVideos];
    }
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isLoading == YES) {
        [LoadingServices hide];
    }
}

-(void) loadVideos {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[self.view subviews] containsObject:self.noInternetView]) {
                return;
            }
            
            __weak typeof(self) weakSelf = self;
            [self.noInternetView setReloadCallback:^{
                [weakSelf loadVideos];
            }];
            
            self.noInternetView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:self.noInternetView];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noInternetView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.topBar
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:0.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noInternetView
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0
                                                                   constant:0.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noInternetView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.bottomLayoutGuide
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0.0]];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.noInternetView
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:0.0]];
            
            [self.view layoutIfNeeded];
        });
    } else {
        self.isLoading = YES;
        [LoadingServices show];
        
        [NHVideosServices getNewestVideos:^(NSArray *videos, NSString *errorMessage) {
            self.isLoading = NO;
            
            if (errorMessage) {
                [LoadingServices fail];
                [Toast showWithText:errorMessage];
            } else {
                [LoadingServices success];
                self.videos = [NSMutableArray arrayWithArray:videos];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[self.view subviews] containsObject:self.noInternetView]) {
                        [self.noInternetView removeFromSuperview];
                        [self.view layoutIfNeeded];
                    }
                    
                    [self.videosTableView reloadData];
                });
            }
        }];

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NHVideo *currentVideo = [self.videos objectAtIndex:indexPath.row];
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire forIndexPath:indexPath];
    
    cell.cellImage.image = [UIImage imageNamed: @"no-image.png"];
    cell.cellLabel.text = currentVideo.title;
    cell.videoURL = currentVideo.videoURL;
    
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor colorWithRed:225.0f/255.0f
                                               green:225.0f/255.0f
                                                blue:225.0f/255.0f
                                               alpha:1];

    } else {
        cell.backgroundColor = [UIColor colorWithRed:245.0f/255.0f
                                               green:245.0f/255.0f
                                                blue:245.0f/255.0f
                                               alpha:1];
    }

    [ImageServices getImage:currentVideo.imageUrl callback:^(UIImage *image, NSString *errorMessage) {
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

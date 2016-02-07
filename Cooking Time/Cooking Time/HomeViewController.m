//
//  HomeViewController.m
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "HomeViewController.h"
#import "NHVideoServices.h"
#import "NHImageServices.h"
#import "NHToastService.h"
#import "VideoTableViewCell.h"
#import "NoInternetView.h"
#import "NHVideo.h"
#import "Reachability.h"
#import "Cooking_Time-Swift.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *videosTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *topBar;
@property NSMutableArray* videos;
@property NoInternetView* noInternetView;
@property BOOL isLoadingVideos;
@property UIRefreshControl *refreshControl;
@end

@implementation HomeViewController

static NSString* defaultImageIdentifire = @"no-image.png";
static NSString* cellIdentifire = @"VideoTableViewCell";
static NSString* noInternetViewIdentifire = @"NoInternetView";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videosTableView.allowsSelection = NO;
    self.videosTableView.dataSource = self;
    self.videosTableView.delegate = self;
    
    UINib* nib = [UINib nibWithNibName:cellIdentifire
                                bundle:nil];
    
    [self.videosTableView registerNib:nib
               forCellReuseIdentifier:cellIdentifire];
    
    self.noInternetView = (NoInternetView *)[[[NSBundle mainBundle] loadNibNamed:noInternetViewIdentifire
                                                                           owner:self
                                                                         options:nil]
                                             objectAtIndex:0];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(loadVideos)
                  forControlEvents:UIControlEventValueChanged];

    [self.videosTableView addSubview:self.refreshControl];
    
    [self loadVideos];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isLoadingVideos == YES) {
        [NHLoadingServices show:@"Loading videos..."];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isLoadingVideos == YES) {
        [NHLoadingServices hide];
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
        self.isLoadingVideos = YES;
        [NHLoadingServices show:@"Loading videos..."];
        
        [NHVideoServices getNewestVideos:^(NSArray *videos, NSString *errorMessage) {
            self.isLoadingVideos = NO;
            
            if (errorMessage) {
                [NHLoadingServices fail];
                [NHToastService showWithText:errorMessage];
            } else {
                [NHLoadingServices success];
                self.videos = [NSMutableArray arrayWithArray:videos];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[self.view subviews] containsObject:self.noInternetView]) {
                        [self.noInternetView removeFromSuperview];
                        [self.view layoutIfNeeded];
                    }
                    
                    [self.videosTableView reloadData];
                    [self.refreshControl endRefreshing];
                });
            }
        }];
    }
}

- (IBAction)goToYouTubeChanel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/playlist?list=PL8PM5J5RodlalW_XqjytpHnDx7AHh2IFT"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NHVideo *currentVideo = [self.videos objectAtIndex:indexPath.row];
    
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire forIndexPath:indexPath];
    cell.cellImage.image = [UIImage imageNamed: defaultImageIdentifire];
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

    [NHImageServices getImage:currentVideo.imageUrl callback:^(UIImage *image, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoTableViewCell *cellToUpdate = (VideoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (cellToUpdate) {
                cellToUpdate.cellImage.image = image;
            }
        });
    }];
    
    return cell;
}

@end

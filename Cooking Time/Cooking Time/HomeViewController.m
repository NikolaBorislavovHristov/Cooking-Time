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
            //NSLog(errorMessage);
            self.videos = [NSMutableArray arrayWithObject: [NHVideo initWithImageUrl:@"" videoURL:@"" andTitle:errorMessage]];
        } else {
            self.videos = [NSMutableArray arrayWithArray:videos];
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.videosTableView reloadData];
        });
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

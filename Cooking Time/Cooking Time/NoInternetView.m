//
//  NoInternetView.m
//  Cooking Time
//
//  Created by Nikola Hristov on 31/1/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

#import "NoInternetView.h"
@interface NoInternetView ()

@property (nonatomic, strong) void (^callback)();

@end

@implementation NoInternetView

- (IBAction)goToSettings:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (IBAction)reload:(UIButton *)sender {
    if (self.callback != nil) {
        self.callback();
    }
}

-(void) setReloadCallback: (void (^)())withCallback; {
    self.callback = withCallback;
}

@end

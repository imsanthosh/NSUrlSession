//
//  ViewController.m
//  NSUrlSession
//
//  Created by Santhosh K on 04/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import "ViewController.h"
#import "WebServiceManager.h"
#import "ImageCache.h"

#import "Constants.h"
#import "Protocols.h"
//#import "NUCategory.h"


#import "NSString+Additions.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatior;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self fetchCategoriesForMovie];
    [self fetchImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper methods
- (void)shouldShowActivityIndicator :(BOOL)shouldShow {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _label.hidden = !shouldShow;
        if(shouldShow)
            [_activityIndicatior startAnimating];
        else
            [_activityIndicatior stopAnimating];
    });
}

#pragma mark - Request method
- (void)fetchImage {
    
    NSString *url = @"http://www.hdwallpapers.in/walls/green_nature_dual_monitor-other.jpg";
    [url SHA256String];
    
    [[ImageCache sharedCache] imageFromURL:url withCallbackHandler:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _imageView.image = image;

        });
    }];

     
}
//
//#pragma FileDownloadTaskDelegate methods
//-(void)downloadedPercentage:(float)percentage {
//    _progressLabel.text = [NSString stringWithFormat:@"%f",percentage];
//    
//}

@end

//
//  ViewController.m
//  NSUrlSession
//
//  Created by Santhosh K on 04/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import "ViewController.h"
#import "WebServiceManager.h"
#import "Constants.h"

#import "NUCategory.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatior;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self fetchCategoriesForMovie];
    
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

- (void)fetchCategoriesForMovie {
    
    [self shouldShowActivityIndicator:YES];
    __weak typeof(self) weakSelf = self;
    
    [[WebServiceManager sharedServiceManager] fetchContentsFromURL:@"" withRequestType:0 andCompletionHandler:^(id response, NSError *error) {
        [weakSelf shouldShowActivityIndicator:NO];
        if(response) {
            
            for (NUCategory *category in response) {
                NSLog(@"categoryName:  %@",category.categoryName);
            }
        }
        
    }];
    
}
@end

//
//  ImageDownloader.m
//  NSUrlSession
//
//  Created by Santhosh K on 06/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader


+ (instancetype)sharedDownloader {
    
    static dispatch_once_t once;
    static ImageDownloader *downloader = nil;
    dispatch_once(&once, ^{
        
        downloader = [[ImageDownloader alloc] init];
    });
    return downloader;
}


- (void)downloadFileFromURL:(NSString *)URLString withCompletionHandler:(DownloadCompletionHandler)completionHandler
{
    
    NSURLSession *URLSession = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [URLSession downloadTaskWithURL:[NSURL URLWithString:URLString] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        completionHandler([UIImage imageWithData:[NSData dataWithContentsOfURL:location]]);
    }];
    [downloadTask resume];
    
}

#pragma mark - NSURLSessionDataDelegate methods

@end

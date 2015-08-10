//
//  ImageDownloader.h
//  NSUrlSession
//
//  Created by Santhosh K on 06/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Protocols.h"

typedef void (^DownloadCompletionHandler)(UIImage *image);

@interface ImageDownloader : NSObject

+ (instancetype)sharedDownloader;

- (void)downloadFileFromURL:(NSString *)URLString withCompletionHandler:(DownloadCompletionHandler)completionHandler;

@end

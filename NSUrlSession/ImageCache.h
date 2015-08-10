//
//  ImageCache.h
//  NSUrlSession
//
//  Created by Santhosh K on 06/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^callbackHandler)(UIImage *image, NSError *error);

@interface ImageCache : NSObject

+ (instancetype)sharedCache;

- (void)imageFromURL:(NSString *)URLString withCallbackHandler:(callbackHandler)handler;
- (void)removeAllDataFromCache;

@end

//
//  ImageCache.m
//  NSUrlSession
//
//  Created by Santhosh K on 06/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import "ImageCache.h"
#import "NSString+Additions.h"
#import "ImageDownloader.h"

#define CACHE_COUNT 25

@interface ImageCache ()
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) NSCache *identicalURLs;

@end


@implementation ImageCache

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedCache {
    static dispatch_once_t once;
    static ImageCache *imageCache ;
    
    dispatch_once(&once, ^ {
        
        imageCache = [ImageCache new];
        imageCache.cache = [NSCache new];
        imageCache.cache.countLimit = CACHE_COUNT;
        imageCache.cache.totalCostLimit = CACHE_COUNT;
        [imageCache.cache setEvictsObjectsWithDiscardedContent:YES];
        
        imageCache.identicalURLs = [NSCache new];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    });
    return imageCache;
}

- (void)didRecieveMemoryWarning:(NSNotification*)notif {
    [_cache removeAllObjects];
}

- (void)imageFromURL:(NSString *)URLString withCallbackHandler:(callbackHandler)handler {
    
    if(URLString  && ![URLString isEqualToString:@""]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *SHA256String = [URLString SHA256String];

            void (^fetchImageBlock)(void) = ^ {
                __block UIImage* cachedImage = nil;
                cachedImage = [_cache objectForKey:SHA256String];
                // check image availability in cache..
                if(cachedImage) {
                    handler(cachedImage, nil);
                    return;
                }
              //check in disk space..
                NSString *cachedImagePath = [self cachedPathForFile:SHA256String];
                cachedImage = [self loadImageFromPath:cachedImagePath];
                if(cachedImage) {
                    [_cache setObject:cachedImage forKey:SHA256String];
                    handler(cachedImage,nil);
                    return;
                }
                // image is not available, download it from the server.
                [_identicalURLs setObject:@[handler] forKey:SHA256String];
                NSString* encodedURL = [URLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[ImageDownloader sharedDownloader] downloadFileFromURL:encodedURL withCompletionHandler:^(UIImage *image) {
                    cachedImage = image;
                    
                    
                    // Inform all the requestors on the completion of image download.
                    NSArray *completionBlockArray = [_identicalURLs objectForKey:SHA256String];
                    dispatch_apply([completionBlockArray count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
                        callbackHandler downloadHandler = [completionBlockArray objectAtIndex:index];
                        if(downloadHandler)
                            downloadHandler(cachedImage, nil);
                        
                    });
                    // remove URL for the downloaded image..
                    [_identicalURLs removeObjectForKey:SHA256String];
                    
                    if(cachedImage) {
                        [_cache setObject:cachedImage forKey:SHA256String];
                        [self saveImage:cachedImage toPath:SHA256String];
                    }
                }];
                
            };
            
            
           NSArray * tasksCompeltionHandler = [_identicalURLs objectForKey:SHA256String];
            
            if(tasksCompeltionHandler) {
                tasksCompeltionHandler = [tasksCompeltionHandler arrayByAddingObject:handler];
                
            } else {
                fetchImageBlock();
            }

        });
    } else {
        handler(nil,nil);
    }
}

- (void)removeAllDataFromCache {
    [_cache removeAllObjects];
    [[NSFileManager defaultManager] removeItemAtPath:[[self class] imageCacheDirectoryPath] error:NULL];
}

#pragma mark - Private methods

#pragma mark - Persistent Store Access methods

+ (NSString*)cacheDirectoryPath
{
    NSArray* searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [searchPaths lastObject];
}


+ (NSString*)imageCacheDirectoryPath
{
    NSString* path = [[self cacheDirectoryPath] stringByAppendingPathComponent:@"Images"];
    NSFileManager* manager = [NSFileManager defaultManager];
    BOOL exists, isDirectory;
    exists = [manager fileExistsAtPath:path isDirectory:&isDirectory];
    if(!exists || !isDirectory)
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    return path;
}


- (void)saveImage:(UIImage*)image toPath:(NSString*)path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString *filePath = [[[self class] imageCacheDirectoryPath ] stringByAppendingPathComponent:path];
    if([manager fileExistsAtPath:filePath]) {
        [manager removeItemAtPath:filePath error:nil];
    }
    
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:filePath atomically:NO];
}

- (UIImage*)loadImageFromPath:(NSString*)path
{
    UIImage* image = nil;
    NSFileManager* manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:path]) {
        image = [[UIImage alloc] initWithContentsOfFile:path];
    }
    
    return image;
}

- (NSString*)cachedPathForFile:(NSString*)fileName
{
    NSString* cachedFilePath = [[[self class] imageCacheDirectoryPath] stringByAppendingPathComponent:fileName];
    return cachedFilePath;
}

@end

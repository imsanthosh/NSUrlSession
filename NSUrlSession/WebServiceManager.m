//
//  WebServiceManager.m
//  NSUrlSession
//
//  Created by Santhosh K on 04/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import "WebServiceManager.h"
#import "WebServiceParser.h"

@interface WebServiceManager ()

@property (strong, nonatomic) NSMutableArray *tasksInProgress;

@end
@implementation WebServiceManager


+ (instancetype)sharedServiceManager {
    
    static dispatch_once_t once;
    static WebServiceManager *serviceManager = nil;
    dispatch_once(&once, ^{
        
        serviceManager = [[WebServiceManager alloc] init];
        serviceManager.tasksInProgress = [NSMutableArray array];
        
    });
    return serviceManager;
    
}

- (void)fetchContentsFromURL:(NSString *)URLString withRequestType:(NSUInteger)requestType andCompletionHandler:(NUcompletionHandler)completionHandler {
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // This will avoid searching a progress task on main thread.
        
        __block BOOL isTasksInProgress = NO;
        __block NSUInteger index;
        [_tasksInProgress enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL *stop) {
            if([task.originalRequest.URL.absoluteString isEqualToString:URLString]) {
                isTasksInProgress = YES;
                index = idx;
            }
        }];
        if(isTasksInProgress) {
            NSURLSessionDataTask *task = [_tasksInProgress objectAtIndex:index];
            [_tasksInProgress removeObjectAtIndex:index];
            [task cancel];
        }
        
        NSURL *url = [NSURL URLWithString:URLString];
        NSURLSession *urlSession = [NSURLSession sharedSession];
            
        NSURLSessionDataTask *sessionDataTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            id parsedData = [[WebServiceParser sharedServiceParser] parseResponse:data forRequestType:requestType];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(parsedData)
                    completionHandler(parsedData,nil);
                else
                    completionHandler(nil, error);
            });
            [_tasksInProgress removeObject:sessionDataTask];
        }];
        
        [_tasksInProgress addObject:sessionDataTask];
        [sessionDataTask resume];
    });

}
@end

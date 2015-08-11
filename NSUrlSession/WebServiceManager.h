//
//  WebServiceManager.h
//  NSUrlSession
//
//  Created by Santhosh K on 04/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NUcompletionHandler)(id response , NSError *error);

@interface WebServiceManager : NSObject


+ (instancetype)sharedServiceManager;

- (void)fetchContentsFromURL:(NSString *)URLString taskDescription:(NSString *)description withRequestType:(NSUInteger)requestType andCompletionHandler:(NUcompletionHandler)completionHandler;


- (void)cancelTasksWithDescription:(NSString *)description;

@end

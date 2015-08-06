//
//  WebServiceParser.m
//  NSUrlSession
//
//  Created by Santhosh K on 04/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import "WebServiceParser.h"
#import "NUCategory.h"

@implementation WebServiceParser

+ (instancetype)sharedServiceParser {
    
    static dispatch_once_t once;
    static WebServiceParser *parser ;
    
    dispatch_once(&once, ^{
        parser = [[WebServiceParser alloc] init];
    });
    
    return parser;
}


- (id)parseResponse:(id)response forRequestType:(RequestType)requestType {
    
    id parsedData = nil;
    if(response) {
        
        NSError *error;
        id serializedData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
        
        if(!error) {
            switch (requestType) {
                case RequestA:
                    parsedData = [self categoryArrayFromResponse:serializedData];
                    break;
                
                case RequestB:
                    break;
                
                case RequestC:
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return parsedData;
}

- (NSMutableArray *)categoryArrayFromResponse:(id)response {
    NSMutableArray *categoryArray = nil;
    if(response && [response isKindOfClass:[NSDictionary class]]) {
        
        id array = [response objectForKey:@"results"];
        if([array isKindOfClass:[NSArray class]]) {
            categoryArray = [NSMutableArray array];

            for (id categoryDict in array) {
                NUCategory *category = [[ NUCategory alloc] initWithDict:categoryDict];
                [categoryArray addObject:category];
                
            }
        }
    }
    
    return categoryArray;
}

@end

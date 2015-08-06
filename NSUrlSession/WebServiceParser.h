//
//  WebServiceParser.h
//  NSUrlSession
//
//  Created by Santhosh K on 04/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface WebServiceParser : NSObject


+ (instancetype)sharedServiceParser;


- (id)parseResponse:(id)response forRequestType:(RequestType)requestType;

@end

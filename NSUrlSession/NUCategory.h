//
//  Category.h
//  NSUrlSession
//
//  Created by Santhosh K on 04/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUCategory : NSObject

@property (nonatomic) NSUInteger categoryId;
@property (nonatomic , strong) NSString *categoryName;


- (instancetype)initWithDict :(NSDictionary *)dict;

@end

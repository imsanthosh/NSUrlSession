//
//  Category.m
//  NSUrlSession
//
//  Created by Santhosh K on 04/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import "NUCategory.h"

@implementation NUCategory

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    
    if(self) {
        _categoryId = [[dict objectForKey:@"id"] integerValue];
        _categoryName = [dict objectForKey:@"name"];
        
    }
    
    return self;
}
@end

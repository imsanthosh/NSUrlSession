//
//  NSString+Additions.m
//  NSUrlSession
//
//  Created by Santhosh K on 06/08/15.
//  Copyright (c) 2015 Santhosh K. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)


- (NSString *)SHA256String {
    const char *source = [self UTF8String];
    unsigned char SHA[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(source, CC_SHA256_DIGEST_LENGTH, SHA);
    
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X",SHA[i] ];
    }
    return result;

}
@end

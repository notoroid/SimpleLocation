/*
 *  urlEncodeUtil.m
 *  Swf2mp3p1
 *
 *  Created by 能登 要 on 09/09/08.
 *  Copyright 2009 能登 要. All rights reserved.
 *
 */

#define URL_ENCODDE_UTIL_IMPL 
#include "URLEncodeUtil.h"
#undef URL_ENCODDE_UTIL_IMPL

EXTERN_DEF NSString* encodeURIComponentFromData(NSData* d)
{
    char* buffer = malloc([d length] + 1);
    memcpy(buffer,[d bytes],[d length]);
    buffer[[d length]] = '\0';
    NSString* result = encodeURIComponent([NSString stringWithUTF8String:buffer] );
    free(buffer);
    return result;
}

NSString* encodeURIComponent(NSString* s) {
    return (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																(__bridge CFStringRef)s,
																NULL,
																(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																kCFStringEncodingUTF8);
}

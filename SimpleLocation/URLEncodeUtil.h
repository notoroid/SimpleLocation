/*
 *  urlEncodeUtil.h
 *  Swf2mp3p1
 *
 *  Created by 能登 要 on 09/09/08.
 *  Copyright 2009 能登 要. All rights reserved.
 *
 */

#ifndef URL_ENCODDE_UTIL_IMPL
#define EXTERN_DEF extern 
#else
#define EXTERN_DEF
#endif

// utility function
EXTERN_DEF NSString* encodeURIComponent(NSString* s);
EXTERN_DEF NSString* encodeURIComponentFromData(NSData* d);


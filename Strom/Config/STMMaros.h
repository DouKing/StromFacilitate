//
//  STMMaros.h
//  WYPersionalIdentity
//
//  Created by WuYikai on 16/3/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#ifndef STMMaros_h
#define STMMaros_h

#ifdef DEBUG
#define STMLog(...) NSLog(__VA_ARGS__)
#define STMLogObj(A) NSLog(@"%@", A)
#define STMLogMethod() NSLog(@"%s", __func__)
#else
#define STMLog(...)
#define STMLogMethod()
#define NSLog(...) {};
#endif

#endif /* STMMaros_h */

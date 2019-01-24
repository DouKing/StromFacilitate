//
//  GlobalDefine.h
//  StromFacilitate
//
//  Created by WuYikai on 16/8/7.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

#ifdef DEBUG
#define STMLog(...) NSLog(__VA_ARGS__)
#define STMLogObj(A) NSLog(@"%@", A)
#define STMLogMethod() NSLog(@"%s", __func__)
#else
#define STMLog(...)
#define STMLogObj(A)
#define STMLogMethod()
#define NSLog(...) {};
#endif

#endif /* GlobalDefine_h */

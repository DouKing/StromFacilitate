//
//  UIDevice+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2018/11/20.
//  Copyright © 2018 DouKing. All rights reserved.
//

#import "UIDevice+STM.h"
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <AdSupport/AdSupport.h>
#import "NSBundle+STM.h"

@interface _STMDeviceBundleClass : NSObject @end
@implementation _STMDeviceBundleClass @end

@implementation UIDevice (STM)

- (NSString *)stm_platformDesc {
  NSString *bundlePath = [[NSBundle bundleForClass:_STMDeviceBundleClass.class] pathForResource:@"STMDeviceInfo" ofType:@"bundle"];
  NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
  NSString *infoPath = [bundle pathForResource:@"device" ofType:@"plist"];
  NSDictionary *deviceInfo = [NSDictionary dictionaryWithContentsOfFile:infoPath];
  NSString *platform = [self stm_platform];
  if (platform) {
    NSString *p = deviceInfo[platform];
    if (p && [p isKindOfClass:NSString.class] && p.length) {
      return p;
    }
  }
  return platform;
}

- (NSString *)stm_platform {
	return [self stm_getSysInfoByName:"hw.machine"];;
}

- (NSString *)stm_hwmodel {
  return [self stm_getSysInfoByName:"hw.model"];
}

- (NSString *)stm_getSysInfoByName:(char *)typeSpecifier {
  size_t size;
  sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
  char *answer = malloc(size);
  sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
  NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
  free(answer);
  return results;
}

- (NSString * )stm_macString {
  int mib[6];
  size_t len;
  char *buf;
  unsigned char *ptr;
  struct if_msghdr *ifm;
  struct sockaddr_dl *sdl;

  mib[0] = CTL_NET;
  mib[1] = AF_ROUTE;
  mib[2] = 0;
  mib[3] = AF_LINK;
  mib[4] = NET_RT_IFLIST;

  if ((mib[5] = if_nametoindex("en0")) == 0) {
    printf("Error: if_nametoindex error\n");
    return NULL;
  }

  if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
    printf("Error: sysctl, take 1\n");
    return NULL;
  }

  if ((buf = malloc(len)) == NULL) {
    printf("Could not allocate memory. error!\n");
    return NULL;
  }

  if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
    printf("Error: sysctl, take 2");
    free(buf);
    return NULL;
  }

  ifm = (struct if_msghdr *)buf;
  sdl = (struct sockaddr_dl *)(ifm + 1);
  ptr = (unsigned char *)LLADDR(sdl);
  NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                         *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
  free(buf);

  return macString;
}

- (NSString *)stm_idfaString {
  NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
  [adSupportBundle load];
  if (adSupportBundle == nil) {
    return @"";
  } else {
    Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
    if(asIdentifierMClass == nil) {
      return @"";
    } else {
      ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
      if (asIM == nil) {
        return @"";
      } else {
        if (asIM.advertisingTrackingEnabled) {
          return [asIM.advertisingIdentifier UUIDString];
        } else {
          return [asIM.advertisingIdentifier UUIDString];
        }
      }
    }
  }
}

- (NSString *)stm_idfvString {
  if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
  }
  return @"";
}

@end

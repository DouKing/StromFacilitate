//
//  AppDelegate.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "AppDelegate.h"
#import "UIDevice+STM.h"
#import "UIApplication+STM.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  UIImage *image = [UIImage imageNamed:@"img_goBack_icon"];
  image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  [[UINavigationBar appearance] setBackIndicatorImage:image];
  [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:image];
  
  UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
  UIOffset offset = UIOffsetMake(-5, 2);
  [buttonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];

  application.stm_statusBarColor = [UIColor redColor];
  STMLog(@"status bar color: %@", application.stm_statusBarColor);
  STMLog(@"device platform: %@", [[UIDevice currentDevice] stm_platform]);
  STMLog(@"system version: %@", [[UIDevice currentDevice] systemVersion]);
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

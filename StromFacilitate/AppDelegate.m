//
//  AppDelegate.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UINavigationController+STMTransition.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
  nav1.transitionStyle = STMNavigationTransitionStyleResignLeft;
  UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
  UITabBarController *tabBarController = [[UITabBarController alloc] init];
  [tabBarController setViewControllers:@[nav1, nav2] animated:YES];

  UITabBarItem *tab1 = tabBarController.tabBar.items[0];
  UITabBarItem *tab2 = tabBarController.tabBar.items[1];
  tab1.title = @"测试1";
  tab2.title = @"测试2";
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = tabBarController;
  [self.window makeKeyAndVisible];
  
  UIImage *image = [UIImage imageNamed:@"img_goBack_icon"];
  image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  [[UINavigationBar appearance] setBackIndicatorImage:image];
  [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:image];
  
  UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
  UIOffset offset = UIOffsetMake(-5, 2);
  [buttonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
  
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

//
//  AppDelegate.m
//  RepoSearch
//
//  Created by chi on 21/12/2016.
//  Copyright © 2016 chi. All rights reserved.
//

#import "AppDelegate.h"
#import "Repository.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    //initiallize user defaults
    // add my own repo
    NSString * key = @"donaldchidonaldchi/RepoSearch";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    Repository * repo = [[Repository alloc] init];
    repo.filename = @"donaldchi/RepoSearch";
    repo.user = @"donaldchi";
    repo.language = @"Objective-C";
    repo.desc = @"Repository Incremental Search program";
    repo.stargazer = @"0";
    repo.fork = @"0";
    repo.update = @"2016/12/27";
    repo.url = @"https://github.com/donaldchi/RepoSearch";
    repo.avatar = @"https://avatars.githubusercontent.com/u/3402798?v=3";
    
    [ud setObject:defaults forKey:@"favorites"];
    [ud registerDefaults:defaults];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

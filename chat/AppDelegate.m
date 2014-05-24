//
//  AppDelegate.m
//  chat
//
//  Created by Kenny on 2014/04/11.
//
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize newMomentFlag;
@synthesize newThingFlag;
@synthesize newChatFlag;

@synthesize newFriendCount;
@synthesize recommendFriendCount;

@synthesize user;
@synthesize friendMap;
@synthesize anewFriendMap;
@synthesize recommendFriendMap;

@synthesize languageType;

//TODO：最近聊天
@synthesize momentUpdateTime;
@synthesize thingUpdateTime;
@synthesize setting;
@synthesize userDB;
@synthesize loginUserDB;
@synthesize settingDB;
@synthesize imageDB;
@synthesize messageDB;
@synthesize recentMessageDB;
@synthesize anewFriendDB;
@synthesize recommendFriendDB;
@synthesize userImage;

@synthesize dataManager;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSMutableDictionary *)launchOptions
{
    // Override point for customization after application launch.
    dataManager = [DataManager sharedDataManager];
    userDB = [UserDB initUserDB];
    loginUserDB = [LoginUserDB initUserDB];
    settingDB = [SettingDB initUserDB];
    imageDB = [ImageDB initDB];
    messageDB = [MessageDB initUserDB];
    recentMessageDB = [RecentMessageDB initUserDB];
    anewFriendDB = [NewFriendDB initUserDB];
    recommendFriendDB = [RecommendFriendDB initUserDB];
    
    user = [[NSMutableDictionary alloc]initWithCapacity:5];
    friendMap = [[NSMutableDictionary alloc]initWithCapacity:5];
    anewFriendMap = [[NSMutableDictionary alloc]initWithCapacity:5];
    recommendFriendMap = [[NSMutableDictionary alloc]initWithCapacity:5];
    setting = [[NSMutableDictionary alloc]initWithCapacity:5];
    
    languageType = @"en";

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end

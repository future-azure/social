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
@synthesize anewMsgNumMap;

@synthesize dataManager;
@synthesize bundle;


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
    anewMsgNumMap = [[NSMutableDictionary alloc]initWithCapacity:5];

    
    languageType = @"en";
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSNumber *userId = [defaults objectForKey:@"userId"];//根据键值取出name
    if (userId != nil) {
        setting = [settingDB getUserSetting:[userId intValue]];
        languageType = [setting objectForKey:@"language"];
    }
    NSString *string;
    if ([@"en" isEqualToString:languageType]) {
        string = @"en";
    } else {
        string = @"zh-Hans";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];

    
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

- (void) showDialog:(NSString *)dialogType content:(NSString*)content {
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:[bundle localizedStringForKey:dialogType value:nil table:@"language"] andMessage:[bundle localizedStringForKey:content value:nil table:@"language"]];
    [alertView addButtonWithTitle:[bundle localizedStringForKey:@"ok" value:nil table:@"language"]                                 type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              //    NSLog(@"OK Clicked");
                              
                          }];
    alertView.titleColor = [UIColor blueColor];
    alertView.cornerRadius = 10;
    alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        //     NSLog(@"%@, willShowHandler2", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        //       NSLog(@"%@, didShowHandler2", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        //      NSLog(@"%@, willDismissHandler2", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        //     NSLog(@"%@, didDismissHandler2", alertView);
    };
    
    [alertView show];
    
}




- (NSString *)md5:(NSString *)str

{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ];
    
}

- (NSString *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData
                                     encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}


@end

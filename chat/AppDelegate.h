//
//  AppDelegate.h
//  chat
//
//  Created by Kenny on 2014/04/11.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "UserDB.h"
#import "LoginUserDB.h"
#import "SettingDB.h"
#import "ImageDB.h"
#import "MessageDB.h"
#import "RecentMessageDB.h"
#import "NewFriendDB.h"
#import "RecommendFriendDB.h"
#import "sqlLite.h"
#import "Constants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    int newMomentFlag;
    int newThingFlag;
    int newChatFlag;
    
    int newFriendCount;
    int recommendFriendCount;
    
    NSMutableDictionary *user;
    NSMutableDictionary *friendMap;
    NSMutableDictionary *anewFriendMap;
    NSMutableDictionary *recommendFriendMap;
    
    NSString *languageType;
    
    //TODO：最近聊天
    NSDate *momentUpdateTime;
    NSDate *thingUpdateTime;
    NSMutableDictionary *setting;
    UserDB *userDB;
    LoginUserDB *loginUserDB;
    SettingDB *settingDB;
    ImageDB *imageDB;
    MessageDB *messageDB;
    RecentMessageDB *recentMessageDB;
    NewFriendDB *anewFriendDB;
    RecommendFriendDB *recommendFriendDB;
    UIImage *userImage;
    
    DataManager *dataManager;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DataManager *dataManager;
@property int newMomentFlag;
@property int newThingFlag;
@property int newChatFlag;

@property int newFriendCount;
@property int recommendFriendCount;

@property (strong, nonatomic) NSMutableDictionary *user;
@property (strong, nonatomic) NSMutableDictionary *friendMap;
@property (strong, nonatomic) NSMutableDictionary *anewFriendMap;
@property (strong, nonatomic) NSMutableDictionary *recommendFriendMap;

@property (strong, nonatomic) NSString *languageType;

//TODO：最近聊天
@property (strong, nonatomic) NSDate *momentUpdateTime;
@property (strong, nonatomic) NSDate *thingUpdateTime;
@property (strong, nonatomic) NSMutableDictionary *setting;
@property (strong, nonatomic) UserDB *userDB;
@property (strong, nonatomic) LoginUserDB *loginUserDB;
@property (strong, nonatomic) SettingDB *settingDB;
@property (strong, nonatomic) ImageDB *imageDB;
@property (strong, nonatomic) MessageDB *messageDB;
@property (strong, nonatomic) RecentMessageDB *recentMessageDB;
@property (strong, nonatomic) NewFriendDB *anewFriendDB;
@property (strong, nonatomic) RecommendFriendDB *recommendFriendDB;
@property (strong, nonatomic) UIImage *userImage;




@end

//
//  GeneralViewController.h
//  chat
//
//  Created by brightvision on 14-5-26.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import "FontSizeSettingViewController.h"
#import "LanguageSettingViewController.h"
#import "UIViewPassValueDelegate.h"

@interface GeneralViewController : UIViewController<UIViewPassValueDelegate>{
    
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    SettingDB *settingDB;
    MessageDB *messageDB;
    RecentMessageDB *recentDB;
    
    NSMutableDictionary *setting;
    
    NSString *userData;
}


@end

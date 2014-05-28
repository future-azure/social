//
//  NotificationViewController.h
//  chat
//
//  Created by brightvision on 14-5-26.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>  

@interface NotificationViewController : UIViewController {
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    NSString *userData;
    
    SettingDB *settingDB;

    NSMutableDictionary *setting;

}

@end

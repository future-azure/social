//
//  PrivacyViewController.h
//  chat
//
//  Created by brightvision on 14-5-26.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"

@interface PrivacyViewController : UIViewController{
    
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    SettingDB *settingDB;
    
    NSMutableDictionary *setting;
    
    NSString *userData;
}

@end

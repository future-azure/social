//
//  ChatBgSettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-28.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"

@interface ChatBgSettingViewController : UIViewController{
    
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    
    DataManager *dataManager;
    
    AppDelegate *myDelegate;    
    SettingDB *settingDB;
    
    NSMutableDictionary *setting;
    
    
    
}


@end

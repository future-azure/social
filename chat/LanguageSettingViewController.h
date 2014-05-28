//
//  LanguageSettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-28.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import "UIViewPassValueDelegate.h"

@interface LanguageSettingViewController : UIViewController{
    
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    NSObject<UIViewPassValueDelegate> * delegate;
    
    SettingDB *settingDB;
    
    NSMutableDictionary *setting;

    
    
}

@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;



@end

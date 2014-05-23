//
//  SettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-6.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import "UIViewPassValueDelegate.h"
#import "ProfileSettingViewController.h"

@interface SettingViewController : UIViewController<MBProgressHUDDelegate,
UIViewPassValueDelegate> {
    MBProgressHUD *HUD;
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    
    DataManager *dataManager;

    AppDelegate *myDelegate;


}

@end

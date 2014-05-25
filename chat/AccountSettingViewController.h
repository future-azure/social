//
//  AccountSettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-25.
//
//

#import <UIKit/UIKit.h>

#import "DataManager.h"
#import "AppDelegate.h"
#import "UIViewPassValueDelegate.h"
#import "EmailSettingViewController.h"
#import "PhoneSettingViewController.h"

@interface AccountSettingViewController : UIViewController<MBProgressHUDDelegate,UIViewPassValueDelegate> {
    NSString *oldFId;
    NSString *oldFName;
    NSString *oldTId;
    NSString *oldTName;
    
    
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    NSString *userData;
    
    MBProgressHUD *HUD;

}

@end

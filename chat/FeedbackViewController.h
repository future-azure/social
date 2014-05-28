//
//  FeedbackViewController.h
//  chat
//
//  Created by brightvision on 14-5-26.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"

@interface FeedbackViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate> {
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    NSString *userData;
    
    MBProgressHUD *HUD;

    
    
    
}

@end

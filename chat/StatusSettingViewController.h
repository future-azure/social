//
//  StatusSettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-23.
//
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"
#import "DataManager.h"
#import "AppDelegate.h"

@interface StatusSettingViewController : UIViewController<UITextFieldDelegate> {
    NSObject<UIViewPassValueDelegate> * delegate;
    NSString *old_status;
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    NSString *userData;

    
    
}
@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;

@end

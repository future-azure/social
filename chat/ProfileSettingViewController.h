//
//  ProfileSettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-12.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import "UIViewPassValueDelegate.h"
#import "NameSettingViewController.h"
#import "RegionSettingViewController.h"
#import "StatusSettingViewController.h"
#import "GenderSettingViewController.h"
#import "IBActionSheet.h"
#import "CaptureViewController.h"

@interface ProfileSettingViewController : UIViewController<MBProgressHUDDelegate,IBActionSheetDelegate, 
UIViewPassValueDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {

    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    IBActionSheet *actionSheet;
    
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    NSObject<UIViewPassValueDelegate> * delegate;
    
    
}

@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;

@end

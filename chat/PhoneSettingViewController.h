//
//  PhoneSettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-25.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import "VerificationViewController.h"


@interface PhoneSettingViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {
    NSMutableArray *pickerArray;
    NSMutableArray *codeArray;

    NSString *veriCode;
    
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    NSString *userData;
    NSString *countryData;
    
    MBProgressHUD *HUD;
    
    
    
}


@end

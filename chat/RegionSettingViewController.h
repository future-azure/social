//
//  RegionSettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-23.
//
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"
#import "DataManager.h"
#import "AppDelegate.h"

@interface RegionSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate> {
    NSObject<UIViewPassValueDelegate> * delegate;
    NSString *regionName;
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    NSString *userData;
    
    NSMutableDictionary *regionMap;
    NSMutableArray *countryList;
    NSMutableArray *regionList;
    NSMutableArray *provinceList;
    NSMutableArray *cityList;
    int old_region_id;
    int mode;
    
    MBProgressHUD *HUD;
    
}
@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;
@property (strong,nonatomic)NSIndexPath *lastpath ;@end

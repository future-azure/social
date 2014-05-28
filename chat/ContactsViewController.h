//
//  ContactsViewController.h
//  chat
//
//  Created by brightvision on 14-5-28.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import "UserCell.h"
#import "UIImageView+WebCache.h"

@interface ContactsViewController : UIViewController<MBProgressHUDDelegate,UITableViewDataSource, UITableViewDelegate> {
    
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    NSMutableDictionary *friendMap;
    NSMutableArray *friendList;
    MBProgressHUD *HUD;
    
    NSString *serverAddress;
    
    NSIndexPath *selectPosition;
    
    NSString *returnString;
}


@end

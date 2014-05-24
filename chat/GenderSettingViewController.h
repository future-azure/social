//
//  GenderSettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-23.
//
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"
#import "DataManager.h"
#import "AppDelegate.h"

@interface GenderSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
 
    NSObject<UIViewPassValueDelegate> * delegate;
    NSString *old_gender;
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    NSString *userData;
    
    NSString *selectGender;
    
    NSArray *genderArray;
    
    NSArray *genderArrayDisplay;  
    
}
@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;
@property (strong,nonatomic)NSIndexPath *lastpath ;


@end

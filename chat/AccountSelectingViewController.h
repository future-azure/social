//
//  AccountSelectingViewController.h
//  chat
//
//  Created by brightvision on 14-5-22.
//
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"
#import "AppDelegate.h"
#import "UserTableViewCell.h"

@interface AccountSelectingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSObject<UIViewPassValueDelegate> * delegate;
    AppDelegate *myDelegate;
    LoginUserDB *db;
    ImageDB *imgdb;
    NSArray *loggedAccount;


}
@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;
@end

//
//  LoginViewController.h
//  chat
//
//  Created by Kenny on 2014/04/11.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "IBActionSheet.h"
#import "AppDelegate.h"
#import "AddressBook.h"
#import "UIViewPassValueDelegate.h"
#import "PhoneLoginViewController.h"
#import "AccountSelectingViewController.h"


@interface LoginViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate,IBActionSheetDelegate, MBProgressHUDDelegate,
UIViewPassValueDelegate> {
    MBProgressHUD *HUD;
    UIScrollView *scrollView;
    UITextField *textField;
    UIButton *switchAccount;
    UIButton *signUp;
    NSString *loginData;
    NSString *type;
    AsyncSocket *socket;
    IBActionSheet *actionSheet;
    NSNumber *accountType;
 //   NSMutableDictionary *user;
    DataManager *dataManager;
    AddressBook *addressBook;
    AppDelegate *myDelegate;
    ImageDB *imgdb;
    MessageDB *msgdb;
    RecentMessageDB *recentMsgDb;
    NSMutableData *imageData;
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *switchAccount;

@property (strong, nonatomic) IBOutlet UIButton *signUp;
@end

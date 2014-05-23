//
//  VerificationViewController.h
//  chat
//
//  Created by brightvision on 14-5-12.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import "AddressBook.h"

@interface VerificationViewController : UIViewController <MBProgressHUDDelegate> {
    AsyncSocket *socket;
    NSString *type;
    NSString *registerUser;
    MBProgressHUD *HUD;
    DataManager *dataManager;
    AddressBook *addressBook;
    AppDelegate *myDelegate;
    ImageDB *imgdb;
    MessageDB *msgdb;
    RecentMessageDB *recentMsgDb;
    NSMutableData *imageData;

}
@property (weak, nonatomic) NSString *phone_number;
@property (weak, nonatomic) NSString *country_code;
@property (weak, nonatomic) NSString *verifiCode;


@end

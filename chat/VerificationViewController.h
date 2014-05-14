//
//  VerificationViewController.h
//  chat
//
//  Created by brightvision on 14-5-12.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface VerificationViewController : UIViewController <MBProgressHUDDelegate> {
    AsyncSocket *socket;
    NSString *type;
    NSString *registerUser;
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) NSString *phone_number;
@property (weak, nonatomic) NSString *country_code;
@property (weak, nonatomic) NSString *verifiCode;


@end

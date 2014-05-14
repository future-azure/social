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

@interface LoginViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate,IBActionSheetDelegate> {
    UIScrollView *scrollView;
    UITextField *textField;
    UIButton *switchAccount;
    UIButton *signUp;
    NSString *loginData;
    NSString *type;
    AsyncSocket *socket;
    IBActionSheet *actionSheet;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *switchAccount;

@property (strong, nonatomic) IBOutlet UIButton *signUp;
@end

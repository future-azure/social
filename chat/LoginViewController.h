//
//  LoginViewController.h
//  chat
//
//  Created by Kenny on 2014/04/11.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate> {
    UIScrollView *scrollView;
    UITextField *textField;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

//
//  RegisterViewController.h
//  chat
//
//  Created by brightvision on 14-4-21.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "VerificationViewController.h"

@interface RegisterViewController : UIViewController<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource> {
    NSMutableArray *pickerArray;
    NSMutableArray *codeArray;
    UIButton *termsCheckBox;
    
}

- (IBAction)finishButton:(id)sender;

@end

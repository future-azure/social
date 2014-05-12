//
//  RegisterViewController.h
//  chat
//
//  Created by brightvision on 14-4-21.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface RegisterViewController : UIViewController<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource> {
    NSArray *pickerArray;
    NSArray *codeArray;
    UIButton *termsCheckBox;
    
}

- (IBAction)finishButton:(id)sender;

@end

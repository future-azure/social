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
    NSMutableArray *pickerArray;
    NSMutableArray *codeArray;
    UIButton *termsCheckBox;
    NSString *countryData;
    NSString *type;
    AsyncSocket *socket;
    NSString *veriCode;
    
    
}

- (IBAction)finishButton:(id)sender;

@end

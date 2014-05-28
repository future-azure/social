//
//  PhoneLoginViewController.h
//  chat
//
//  Created by brightvision on 14-5-22.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import "UIViewPassValueDelegate.h"

@interface PhoneLoginViewController : UIViewController<UIPickerViewDelegate, UITextFieldDelegate,UIPickerViewDataSource> {
    NSMutableArray *pickerArray;
    NSMutableArray *codeArray;
    UIButton *termsCheckBox;
    NSString *countryData;
    NSString *type;
    NSString *veriCode;
    AsyncSocket *socket;
    DataManager *dataManager;
    NSObject<UIViewPassValueDelegate> * delegate;
    AppDelegate *myDelegate;
    
}

- (IBAction)finishButton:(id)sender;
@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;


@end

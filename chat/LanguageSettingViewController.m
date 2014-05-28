//
//  LanguageSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-28.
//
//

#import "LanguageSettingViewController.h"

@interface LanguageSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *en;
@property (weak, nonatomic) IBOutlet UIButton *ch;
@property (weak, nonatomic) IBOutlet UISwitch *enCheck;
@property (weak, nonatomic) IBOutlet UISwitch *chCheck;

@end

@implementation LanguageSettingViewController
@synthesize title;
@synthesize en;
@synthesize ch;
@synthesize enCheck;
@synthesize chCheck;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     myDelegate = [[UIApplication sharedApplication] delegate];
    title.text = [myDelegate.bundle localizedStringForKey:@"language" value:nil table:@"language"];
    
    [en setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"english" value:nil table:@"language"]] forState:UIControlStateNormal];
    [ch setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"chinese" value:nil table:@"language"]] forState:UIControlStateNormal];
    
  //  myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    user = myDelegate.user;
    
    settingDB = myDelegate.settingDB;
    setting = myDelegate.setting;
    
    NSString *language = setting[@"language"];
    if ([@"en" isEqualToString:language]) {
        [enCheck setOn:true];
        [chCheck setOn:false];
    } else {
        [enCheck setOn:false];
        [chCheck setOn:true];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)enClick:(id)sender {
    if (!enCheck.isOn) {
        [enCheck setOn:true];
        [chCheck setOn:false];
        [self alertWindow:@"en"];
    }
    
}

- (IBAction)chClick:(id)sender {
    if (!chCheck.isOn) {
        [chCheck setOn:true];
        [enCheck setOn:false];
        [self alertWindow:@"zh"];
    }
}

-(void) alertWindow:(NSString*) language {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:[myDelegate.bundle localizedStringForKey:@"info" value:nil table:@"language"] andMessage:[myDelegate.bundle localizedStringForKey:@"language_change" value:nil table:@"language"]];
    [alertView addButtonWithTitle:[myDelegate.bundle localizedStringForKey:@"cancel" value:nil table:@"language"]
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              //   NSLog(@"Cancel Clicked");
                          }];
    [alertView addButtonWithTitle:[myDelegate.bundle localizedStringForKey:@"ok" value:nil table:@"language"]
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              //     NSLog(@"OK Clicked");
                              [setting setObject:language forKey:@"language"];
                              [settingDB saveSetting:[user[@"id"] intValue] userSetting:setting];
                              myDelegate.setting = setting;
                              [self performSegueWithIdentifier:@"changeLanguage" sender:self];

                          }];
    alertView.titleColor = [UIColor blueColor];
    alertView.cornerRadius = 10;
    alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        //      NSLog(@"%@, willShowHandler2", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        //       NSLog(@"%@, didShowHandler2", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        //       NSLog(@"%@, willDismissHandler2", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        //        NSLog(@"%@, didDismissHandler2", alertView);
    };
    
    [alertView show];
}

@end

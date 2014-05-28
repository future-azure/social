//
//  GeneralViewController.m
//  chat
//
//  Created by brightvision on 14-5-26.
//
//

#import "GeneralViewController.h"

@interface GeneralViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *enterSend;
@property (weak, nonatomic) IBOutlet UIButton *language;
@property (weak, nonatomic) IBOutlet UILabel *curLanguage;
@property (weak, nonatomic) IBOutlet UIButton *fontSize;
@property (weak, nonatomic) IBOutlet UILabel *curFontSize;
@property (weak, nonatomic) IBOutlet UIButton *chatBg;
@property (weak, nonatomic) IBOutlet UIButton *clearChatHistory;
@property (weak, nonatomic) IBOutlet UISwitch *enterSendCheck;

@end

@implementation GeneralViewController
@synthesize title;
@synthesize enterSend;
@synthesize language;
@synthesize curFontSize;
@synthesize curLanguage;
@synthesize fontSize;
@synthesize chatBg;
@synthesize clearChatHistory;
@synthesize enterSendCheck;

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
    title.text = [myDelegate.bundle localizedStringForKey:@"general" value:nil table:@"language"];
    
    [enterSend setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"enter_send" value:nil table:@"language"]] forState:UIControlStateNormal];
    [language setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"language" value:nil table:@"language"]] forState:UIControlStateNormal];
    [fontSize setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"font_size" value:nil table:@"language"]] forState:UIControlStateNormal];
    [chatBg setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"chat_bg" value:nil table:@"language"]] forState:UIControlStateNormal];
    [clearChatHistory setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"clear_chat_history" value:nil table:@"language"]] forState:UIControlStateNormal];
    
    
    userData = @"";
    
   // myDelegate = [[UIApplication sharedApplication] delegate];
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
    messageDB = myDelegate.messageDB;
    recentDB = myDelegate.recentMessageDB;
    
    curFontSize.text = [self getFontSize];
    curFontSize.font = [UIFont fontWithName:@"STHeiti-Medium.ttc" size:[setting[@"fontSize"] intValue]];
    curLanguage.text = setting[@"language"];
    [enterSendCheck setOn:[setting[@"enterSend"] intValue] == 1? true : false];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) getFontSize{
    switch ([setting[@"fontSize"] intValue]) {
        case 16:
            return [myDelegate.bundle localizedStringForKey:@"small" value:nil table:@"language"];
        case 18:
            return [myDelegate.bundle localizedStringForKey:@"medium" value:nil table:@"language"];

        case 20:
            return [myDelegate.bundle localizedStringForKey:@"large" value:nil table:@"language"];

        case 22:
            return [myDelegate.bundle localizedStringForKey:@"extra_large" value:nil table:@"language"];

        case 24:
            return [myDelegate.bundle localizedStringForKey:@"super_large" value:nil table:@"language"];

            
        default:
           return [myDelegate.bundle localizedStringForKey:@"medium" value:nil table:@"language"];
    }
}

- (IBAction)enterSend:(id)sender {
    [enterSendCheck setOn: enterSendCheck.isOn? false : true];
    if (enterSendCheck.isOn) {
        [setting setObject:[NSNumber numberWithInt:1] forKey:@"enterSend"];
    } else {
       [setting setObject:[NSNumber numberWithInt:0] forKey:@"enterSend"];
    }
    [settingDB saveSetting:[user[@"id"] intValue] userSetting:setting];
    
}
- (IBAction)language:(id)sender {
    [self performSegueWithIdentifier:@"language" sender:self];

}
- (IBAction)fontSize:(id)sender {
    [self performSegueWithIdentifier:@"fontSize" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"language"]) //"goView2"是SEGUE连线的标识
    {
        // id theSegue = segue.destinationViewController;
        LanguageSettingViewController *phoneLogin=
        
        segue.destinationViewController;
        
        phoneLogin.delegate = self;
    }
    if([segue.identifier isEqualToString:@"fontSize"]) //"goView2"是SEGUE连线的标识
    {
        // id theSegue = segue.destinationViewController;
        FontSizeSettingViewController *phoneLogin=
        
        segue.destinationViewController;
        
        phoneLogin.delegate = self;
    }
}


- (IBAction)clearHistory:(id)sender {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:[myDelegate.bundle localizedStringForKey:@"info" value:nil table:@"language"] andMessage:[myDelegate.bundle localizedStringForKey:@"clear_chat_history_confirm" value:nil table:@"language"]];
    [alertView addButtonWithTitle:[myDelegate.bundle localizedStringForKey:@"cancel" value:nil table:@"language"]
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alertView) {
                              //   NSLog(@"Cancel Clicked");
                          }];
    [alertView addButtonWithTitle:[myDelegate.bundle localizedStringForKey:@"ok" value:nil table:@"language"]
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              //     NSLog(@"OK Clicked");
                              [messageDB clearAllMsg:[user[@"id"] intValue]];
                              [recentDB clearAllMsg:[user[@"id"] intValue]];
                             // myDelegate.re
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
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void) passValue:(NSString *)value {
    settingDB = myDelegate.settingDB;
    setting = [settingDB getUserSetting:[user[@"id"] intValue]];
    curFontSize.text = [self getFontSize];
    curFontSize.font = [UIFont fontWithName:@"STHeiti-Medium.ttc" size:[setting[@"fontSize"] intValue]];
    curLanguage.text = setting[@"language"];

}

-(void) passUser:(NSDictionary *)value {
    
}

-(void) passImage:(UIImage *)image {
    
}

@end

//
//  OfferFeatureViewController.m
//  chat
//
//  Created by brightvision on 14-5-27.
//
//

#import "OfferFeatureViewController.h"

@interface OfferFeatureViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *wholeRadio;
@property (weak, nonatomic) IBOutlet UIButton *nightRadio;
@property (weak, nonatomic) IBOutlet UIButton *closeRadio;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UISwitch *wholeDayCehck;
@property (weak, nonatomic) IBOutlet UISwitch *nightCheck;
@property (weak, nonatomic) IBOutlet UISwitch *closeCheck;

@end

@implementation OfferFeatureViewController
@synthesize title;
@synthesize wholeDayCehck;
@synthesize wholeRadio;
@synthesize nightCheck;
@synthesize nightRadio;
@synthesize closeCheck;
@synthesize closeRadio;
@synthesize comment;

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
    
    title.text = [myDelegate.bundle localizedStringForKey:@"feature_alert" value:nil table:@"language"];
    
    [wholeRadio setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"whole_day" value:nil table:@"language"]] forState:UIControlStateNormal];
    [nightRadio setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"in_night" value:nil table:@"language"]] forState:UIControlStateNormal];
    [closeRadio setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"close" value:nil table:@"language"]] forState:UIControlStateNormal];
    
    comment.text = [myDelegate.bundle localizedStringForKey:@"no_alert_time" value:nil table:@"language"];
    
    
   
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
    
    switch ([setting[@"offer"] intValue]) {
        case 0:
            [closeCheck setOn:true];
            [wholeDayCehck setOn:false];
            [nightCheck setOn:false];
            break;
        case 1:
            [closeCheck setOn:false];
            [wholeDayCehck setOn:true];
            [nightCheck setOn:false];
            break;
        case 2:
            [closeCheck setOn:false];
            [wholeDayCehck setOn:false];
            [nightCheck setOn:true];
            break;
            
        default:
            break;
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

- (IBAction)wholeClick:(id)sender {
    if (!wholeDayCehck.isOn) {
        [closeCheck setOn:false];
        [wholeDayCehck setOn:true];
        [nightCheck setOn:false];
        [self updateSetting:[NSNumber numberWithInt:1]];
    }
}
- (IBAction)nightClick:(id)sender {
    if (!nightCheck.isOn) {
        [closeCheck setOn:false];
        [wholeDayCehck setOn:false];
        [nightCheck setOn:true];
        [self updateSetting:[NSNumber numberWithInt:2]];     }
}
- (IBAction)closeClick:(id)sender {
    if (!closeCheck.isOn) {
        [closeCheck setOn:true];
        [wholeDayCehck setOn:false];
        [nightCheck setOn:false];
        [self updateSetting:[NSNumber numberWithInt:0]];
    }
    
}

- (void) updateSetting:(NSNumber *)num {
    [setting setObject:num forKey:@"offer"];
    
    [settingDB saveSetting:[[myDelegate.user objectForKey:@"id"] intValue] userSetting:setting];
}

@end

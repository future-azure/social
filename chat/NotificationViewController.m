//
//  NotificationViewController.m
//  chat
//
//  Created by brightvision on 14-5-26.
//
//

#import "NotificationViewController.h"

@interface NotificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *alert;

@property (weak, nonatomic) IBOutlet UIButton *sound;
@property (weak, nonatomic) IBOutlet UIButton *vibe;

@property (weak, nonatomic) IBOutlet UIButton *notifySound;
@property (weak, nonatomic) IBOutlet UIButton *notifyTime;
@property (weak, nonatomic) IBOutlet UIButton *featureAlert;

@property (weak, nonatomic) IBOutlet UISwitch *messageAlert;
@property (weak, nonatomic) IBOutlet UISwitch *alertSound;
@property (weak, nonatomic) IBOutlet UISwitch *appVibrate;

@end

@implementation NotificationViewController
@synthesize title;
@synthesize alert;
@synthesize sound;
@synthesize vibe;
@synthesize notifySound;
@synthesize notifyTime;
@synthesize featureAlert;
@synthesize messageAlert;
@synthesize alertSound;
@synthesize appVibrate;

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
    title.text = [myDelegate.bundle localizedStringForKey:@"notifications" value:nil table:@"language"];
    
    [alert setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"message_alert" value:nil table:@"language"]] forState:UIControlStateNormal];
    [sound setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"alert_sound" value:nil table:@"language"]] forState:UIControlStateNormal];
    [vibe setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"app_vibrate" value:nil table:@"language"]] forState:UIControlStateNormal];
    [notifySound setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"notify_sound" value:nil table:@"language"]] forState:UIControlStateNormal];
    [notifyTime setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"notify_time" value:nil table:@"language"]] forState:UIControlStateNormal];
    [featureAlert setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"feature_alert" value:nil table:@"language"]] forState:UIControlStateNormal];
    
    userData = @"";
   
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
    
    if ([[setting objectForKey:@"alert"] intValue] == 1) {
        [messageAlert setOn:true];
    } else {
        [self visibleChange:false];
    }
    
    if ([[setting objectForKey:@"sound"] intValue] == 1) {
        [alertSound setOn:true];
    } else {
        notifySound.hidden = YES;
    }
    
    [appVibrate setOn:[[setting objectForKey:@"vibe"] intValue] == 1? true : false];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)alertClick:(id)sender {
    if (messageAlert.isOn) {
        [messageAlert setOn:false];
        [self visibleChange:false];
        [setting setObject:[NSNumber numberWithInt:0] forKey:@"alert"];
    } else {
        [messageAlert setOn:true];
        [self visibleChange:true];
        [setting setObject:[NSNumber numberWithInt:1] forKey:@"alert"];

    }
    [self updateSetting];
}

- (void) visibleChange:(BOOL) flag {
    if (flag) {
        sound.hidden = NO;
        alertSound.hidden = NO;
        vibe.hidden = NO;
        appVibrate.hidden = NO;

        if (alertSound.isOn) {
            notifySound.hidden = NO;
        }
        notifyTime.hidden = NO;
    } else {
        sound.hidden = YES;
        alertSound.hidden = YES;
        vibe.hidden = YES;
        appVibrate.hidden = YES;
        notifySound.hidden = YES;
        notifyTime.hidden = YES;
    }
}

- (void) soundVisibleChange:(BOOL) flag {
    if (flag) {
        notifySound.hidden = NO;
        
    } else {
        notifySound.hidden = YES;
    }
}

- (void) updateSetting {
    [settingDB saveSetting:[[myDelegate.user objectForKey:@"id"] intValue] userSetting:setting];
}
 
- (IBAction)soundClick:(id)sender {
    if (alertSound.isOn) {
        [alertSound setOn:false];
        [self soundVisibleChange:false];
        [setting setObject:[NSNumber numberWithInt:0] forKey:@"sound"];
    } else {
        [alertSound setOn:true];
        [self soundVisibleChange:true];
        [setting setObject:[NSNumber numberWithInt:1] forKey:@"sound"];
        if ([@"" isEqualToString:[setting objectForKey:@"soundName"]] || [setting objectForKey:@"soundName"] == nil) {
            [setting setObject:[self getSystemSound] forKey:@"soundName"];
        }
    }
    [self updateSetting];
}

- (NSString *) getSystemSound {
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sound"
                                                     ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    
    return dict[@"1000"];

}

             
- (IBAction)vibeClick:(id)sender {
    [appVibrate setOn:appVibrate.isOn ? false : true];
    [setting setObject:appVibrate.isOn ?[NSNumber numberWithInt:1]: [NSNumber numberWithInt:0] forKey:@"vibe"];
    [self updateSetting];

}


@end

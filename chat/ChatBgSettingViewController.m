//
//  ChatBgSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-28.
//
//

#import "ChatBgSettingViewController.h"

@interface ChatBgSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *grayXuan;
@property (weak, nonatomic) IBOutlet UIImageView *ziXuan;
@property (weak, nonatomic) IBOutlet UIImageView *greenXuan;

@end

@implementation ChatBgSettingViewController
@synthesize title;
@synthesize grayXuan;
@synthesize ziXuan;
@synthesize greenXuan;

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
    title.text = [myDelegate.bundle localizedStringForKey:@"chat_bg" value:nil table:@"language"];
    
    
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
    
    int bg = [setting[@"chatBg"] intValue];
    if (bg == 1) {
        greenXuan.hidden = NO;
        ziXuan.hidden = YES;
        greenXuan.hidden = YES;
    } else if (bg == 2) {
        greenXuan.hidden = YES;
        ziXuan.hidden = NO;
        greenXuan.hidden = YES;

    } else if(bg == 3) {
        greenXuan.hidden = NO;
        ziXuan.hidden = NO;
        greenXuan.hidden = YES;

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

- (IBAction)gray:(id)sender {
    grayXuan.hidden = NO;
    ziXuan.hidden = YES;
    greenXuan.hidden = YES;
    [setting setObject:[NSNumber numberWithInt:1] forKey:@"chatBg"];
    [settingDB saveSetting:[user[@"id"] intValue] userSetting:setting];
}
- (IBAction)zi:(id)sender {
    grayXuan.hidden = YES;
    ziXuan.hidden = NO;
    greenXuan.hidden = YES;

    [setting setObject:[NSNumber numberWithInt:2] forKey:@"chatBg"];
    [settingDB saveSetting:[user[@"id"] intValue] userSetting:setting];

}
- (IBAction)green:(id)sender {
    grayXuan.hidden = YES;
    ziXuan.hidden = YES;
    greenXuan.hidden = NO;
    [setting setObject:[NSNumber numberWithInt:3] forKey:@"chatBg"];
    [settingDB saveSetting:[user[@"id"] intValue] userSetting:setting];

}

@end

//
//  FontSizeSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-28.
//
//

#import "FontSizeSettingViewController.h"

@interface FontSizeSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *small;
@property (weak, nonatomic) IBOutlet UIButton *meduim;
@property (weak, nonatomic) IBOutlet UIButton *large;
@property (weak, nonatomic) IBOutlet UIButton *extraLarge;
@property (weak, nonatomic) IBOutlet UIButton *superLarge;
@property (weak, nonatomic) IBOutlet UISwitch *smallCheck;
@property (weak, nonatomic) IBOutlet UISwitch *meduimCheck;
@property (weak, nonatomic) IBOutlet UISwitch *largeCheck;
@property (weak, nonatomic) IBOutlet UISwitch *extraCheck;
@property (weak, nonatomic) IBOutlet UISwitch *superCheck;

@end

@implementation FontSizeSettingViewController
@synthesize title;
@synthesize small;
@synthesize meduim;
@synthesize large;
@synthesize extraLarge;
@synthesize superCheck;
@synthesize superLarge;
@synthesize smallCheck;
@synthesize meduimCheck;
@synthesize largeCheck;
@synthesize extraCheck;
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
    title.text = [myDelegate.bundle localizedStringForKey:@"font_size" value:nil table:@"language"];
    
    [small setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"small" value:nil table:@"language"]] forState:UIControlStateNormal];
    [meduim setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"medium" value:nil table:@"language"]] forState:UIControlStateNormal];
    [large setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"large" value:nil table:@"language"]] forState:UIControlStateNormal];
    [extraLarge setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"extra_large" value:nil table:@"language"]] forState:UIControlStateNormal];
    [superLarge setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"super_large" value:nil table:@"language"]] forState:UIControlStateNormal];
    
 //   myDelegate = [[UIApplication sharedApplication] delegate];
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
    
    int size = [setting[@"fontSize"] intValue];
    if (size == 16) {
        [smallCheck setOn:true];
        [meduimCheck setOn:false];
        [largeCheck setOn:false];
        [extraCheck setOn:false];
        [superCheck setOn:false];
        
    } else if (size == 18) {
        [smallCheck setOn:false];
        [meduimCheck setOn:true];
        [largeCheck setOn:false];
        [extraCheck setOn:false];
        [superCheck setOn:false];

    } else if(size == 20) {
        [smallCheck setOn:false];
        [meduimCheck setOn:false];
        [largeCheck setOn:true];
        [extraCheck setOn:false];
        [superCheck setOn:false];

    } else if(size == 22) {
        [smallCheck setOn:false];
        [meduimCheck setOn:false];
        [largeCheck setOn:false];
        [extraCheck setOn:true];
        [superCheck setOn:false];

    } else if (size == 24) {
        [smallCheck setOn:false];
        [meduimCheck setOn:false];
        [largeCheck setOn:false];
        [extraCheck setOn:false];
        [superCheck setOn:true];

    }

}

-(void) settingFontSize:(int) size {
    [setting setObject:[NSNumber numberWithInt:size] forKey:@"fontSize"];
    [settingDB saveSetting:[user[@"id"] intValue] userSetting:setting];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [delegate passValue:@""];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)smallClick:(id)sender {
    [smallCheck setOn:true];
    [meduimCheck setOn:false];
    [largeCheck setOn:false];
    [extraCheck setOn:false];
    [superCheck setOn:false];
    [self settingFontSize:16];
}
- (IBAction)mediumClick:(id)sender {
    [smallCheck setOn:false];
    [meduimCheck setOn:true];
    [largeCheck setOn:false];
    [extraCheck setOn:false];
    [superCheck setOn:false];
    [self settingFontSize:18];
}
- (IBAction)largeClick:(id)sender {
    [smallCheck setOn:false];
    [meduimCheck setOn:false];
    [largeCheck setOn:true];
    [extraCheck setOn:false];
    [superCheck setOn:false];

    [self settingFontSize:20];
}
- (IBAction)extraClick:(id)sender {
    [smallCheck setOn:false];
    [meduimCheck setOn:false];
    [largeCheck setOn:false];
    [extraCheck setOn:true];
    [superCheck setOn:false];

    [self settingFontSize:22];
}
- (IBAction)superClick:(id)sender {
    [smallCheck setOn:false];
    [meduimCheck setOn:false];
    [largeCheck setOn:false];
    [extraCheck setOn:false];
    [superCheck setOn:true];
    [self settingFontSize:24];
}

@end

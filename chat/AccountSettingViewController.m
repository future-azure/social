//
//  AccountSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-25.
//
//

#import "AccountSettingViewController.h"

@interface AccountSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *userId;

@property (weak, nonatomic) IBOutlet UIButton *password;
@property (weak, nonatomic) IBOutlet UIButton *email;
@property (weak, nonatomic) IBOutlet UIButton *facebook;
@property (weak, nonatomic) IBOutlet UIButton *twitter;
@property (weak, nonatomic) IBOutlet UIButton *mobile;
@property (weak, nonatomic) IBOutlet UILabel *curFacebook;
@property (weak, nonatomic) IBOutlet UILabel *curTwitter;
@property (weak, nonatomic) IBOutlet UILabel *curMobile;

@property (weak, nonatomic) IBOutlet UILabel *curEmail;
@end

@implementation AccountSettingViewController
@synthesize title;
@synthesize userId;
@synthesize password;
@synthesize email;
@synthesize facebook;
@synthesize twitter;
@synthesize mobile;
@synthesize curEmail;
@synthesize curFacebook;
@synthesize curMobile;
@synthesize curTwitter;

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

    title.text = [myDelegate.bundle localizedStringForKey:@"account" value:nil table:@"language"];
    userId.text = [myDelegate.bundle localizedStringForKey:@"id" value:nil table:@"language"];
    
    [password setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"pw" value:nil table:@"language"]] forState:UIControlStateNormal];
    [email setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"email" value:nil table:@"language"]] forState:UIControlStateNormal];
    [facebook setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"facebook" value:nil table:@"language"]] forState:UIControlStateNormal];
    [twitter setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"twitter" value:nil table:@"language"]] forState:UIControlStateNormal];
    [mobile setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"phone" value:nil table:@"language"]] forState:UIControlStateNormal];
    
    userData = @"";
    
        if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    user = myDelegate.user;
    
    userId.text = [[user objectForKey:@"id"] stringValue];
    curEmail.text = [user objectForKey:@"email"];
    curFacebook.text = [user objectForKey:@"fPassword"];
    curTwitter.text = [user objectForKey:@"tPassword"];
    curMobile.text = [user objectForKey:@"phoneNum"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"emailSetting"]) //"goView2"是SEGUE连线的标识
    {
        // id theSegue = segue.destinationViewController;
        EmailSettingViewController *phoneLogin=
        
        segue.destinationViewController;
        
        phoneLogin.delegate = self;
    }

}



- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)facebookSetting:(id)sender {
    //[self performSegueWithIdentifier:@"profile_setting" sender:self];
}
- (IBAction)twitterSetting:(id)sender {
   // [self performSegueWithIdentifier:@"profile_setting" sender:self];
}
- (IBAction)mobileSetting:(id)sender {
    [self performSegueWithIdentifier:@"phoneSetting" sender:self];
}
- (IBAction)emailSetting:(id)sender {
    [self performSegueWithIdentifier:@"emailSetting" sender:self];

}

- (void)passValue:(NSString *)value {
    user = myDelegate.user;
    curEmail.text = [user objectForKey:@"email"];
    curFacebook.text = [user objectForKey:@"fPassword"];
    curTwitter.text = [user objectForKey:@"tPassword"];
    curMobile.text = [user objectForKey:@"phoneNum"];
}

- (void)passUser:(NSDictionary *)value {
    
}

- (void)passImage:(UIImage *)image {
    
}

@end

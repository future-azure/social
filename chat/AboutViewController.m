//
//  AboutViewController.m
//  chat
//
//  Created by brightvision on 14-5-25.
//
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *versionId;
@property (weak, nonatomic) IBOutlet UIButton *rate;
@property (weak, nonatomic) IBOutlet UIButton *about;
@property (weak, nonatomic) IBOutlet UIButton *follow_facebook;
@property (weak, nonatomic) IBOutlet UIButton *follow_twitter;
@property (weak, nonatomic) IBOutlet UIButton *feedback;
@property (weak, nonatomic) IBOutlet UIButton *check_update;
@property (weak, nonatomic) IBOutlet UIButton *terms;

@end

@implementation AboutViewController
@synthesize title;
@synthesize version;
@synthesize versionId;
@synthesize rate;
@synthesize about;
@synthesize follow_facebook;
@synthesize follow_twitter;
@synthesize feedback;
@synthesize check_update;
@synthesize terms;

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
    dataManage = [DataManager sharedDataManager];
    title.text = [myDelegate.bundle localizedStringForKey:@"about" value:nil table:@"language"];
    version.text =[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"app_ver" value:nil table:@"language"]] ;
    [rate setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"rate_app" value:nil table:@"language"]] forState:UIControlStateNormal];
    [about setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"about_app" value:nil table:@"language"]] forState:UIControlStateNormal];
    [follow_facebook setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"like_f" value:nil table:@"language"]] forState:UIControlStateNormal];
    [follow_twitter setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"follow_t" value:nil table:@"language"]] forState:UIControlStateNormal];
    [feedback setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"feedback" value:nil table:@"language"]] forState:UIControlStateNormal];
    [check_update setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"check_update" value:nil table:@"language"]] forState:UIControlStateNormal];
    [terms setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"terms_privacy" value:nil table:@"language"]] forState:UIControlStateNormal];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // app版本
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    versionId.text = app_Version;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)rate:(id)sender {
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa     /wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                     @"appId" ];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)followFacebook:(id)sender {
}
- (IBAction)followTwitter:(id)sender {
}
- (IBAction)checkUpdate:(id)sender {
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    //TODO:
    NSString *URL = @"http://itunes.apple.com/lookup?id=你的应用程序的ID";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    
    NSData *data1 = [results dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            
            NSString *message = [NSString stringWithFormat:@"%@%@%@", [myDelegate.bundle localizedStringForKey:@"find_new_ver" value:nil table:@"language"], @" ", lastVersion];
            
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:[myDelegate.bundle localizedStringForKey:@"update" value:nil table:@"language"] andMessage:message];
            [alertView addButtonWithTitle:[myDelegate.bundle localizedStringForKey:@"cancel" value:nil table:@"language"]
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alertView) {
                                      //   NSLog(@"Cancel Clicked");
                                  }];
            [alertView addButtonWithTitle:[myDelegate.bundle localizedStringForKey:@"ok" value:nil table:@"language"]
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      //     NSLog(@"OK Clicked");
                                      NSURL *url = [NSURL URLWithString:@"https://itunes.apple.comcn/app/appId"];
                                      [[UIApplication sharedApplication]openURL:url];
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
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@%@%@", currentVersion, @" ", [myDelegate.bundle localizedStringForKey:@"latest_ver" value:nil table:@"language"]];
            [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"update" value:nil table:@"language"] content:message];
        }
    }
}


@end

//
//  PasswordSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-25.
//
//

#import "PasswordSettingViewController.h"

@interface PasswordSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *oriPassword;
@property (weak, nonatomic) IBOutlet UILabel *passConfirm;
@property (weak, nonatomic) IBOutlet UITextField *oriText;

@property (weak, nonatomic) IBOutlet UITextField *confirmText;
@property (weak, nonatomic) IBOutlet UILabel *aNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *aNewText;

@end

@implementation PasswordSettingViewController
@synthesize title;
@synthesize oriPassword;
@synthesize aNewPassword;
@synthesize passConfirm;
@synthesize oriText;
@synthesize aNewText;
@synthesize confirmText;

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
    title.text = NSLocalizedString(@"password", nil);
    oriPassword.text = NSLocalizedString(@"ori_pw", nil);

    aNewPassword.text = NSLocalizedString(@"new_pw", nil);

    passConfirm.text = NSLocalizedString(@"new_pw", nil);

    
    oriText.placeholder = NSLocalizedString(@"ori_pw_hint", nil);
    oriText.secureTextEntry = true;
    aNewText.placeholder = NSLocalizedString(@"new_pw_hint", nil);
    aNewText.secureTextEntry = true;
    confirmText.placeholder = NSLocalizedString(@"con_new_pw_hint", nil);
    confirmText.secureTextEntry = true;
    
    userData = @"";
    
    myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    user = myDelegate.user;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)confrim:(id)sender {
    if ([@"" isEqualToString:oriText.text] || [@"" isEqualToString:aNewText.text] || [@"" isEqualToString:confirmText.text]) {
        [dataManager showDialog:NSLocalizedString(@"info", nil) content:NSLocalizedString(@"pw_empty", nil)];
        return;
    }
    if (![[dataManager md5:oriText.text] isEqualToString:[user objectForKey:@"password"]]) {
        [dataManager showDialog:NSLocalizedString(@"error", nil) content:NSLocalizedString(@"pw_not_correct", nil)];
        return;
    }
    if (![aNewText.text isEqualToString:confirmText.text]) {
        [dataManager showDialog:NSLocalizedString(@"error", nil) content:NSLocalizedString(@"pw_not_equal", nil)];
        return;
    }
    [user setObject:[dataManager md5:aNewText.text] forKey:@"password"];
    [user setObject:@"PASSWORD" forKey:@"updateType"];
    [self updateUser];
    
}

- (void)updateUser {
    // [self showHubLoading:NSLocalizedString(@"logging_out", nil)];
    
    type = @"UPDATEUSER";
    NSString *json;
    NSString *temp = @"\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = @"{\"type\":\"UPDATEUSER\",\"object\":\"";
    NSString *mapString = [dataManager toJSONData:user];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\"" withString:@"\\\""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\r" withString:@""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\n" withString:@""];
    
    json = [json stringByAppendingFormat:@"%@%@",mapString, temp];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
    // [self closeHubLoading];
    //  [socket disconnect];
    //  [self performSegueWithIdentifier:@"re_login" sender:self];
    
    
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    
    if([@"UPDATEUSER" isEqualToString:type]) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        userData =[userData stringByAppendingString:str];
        BOOL isSuffix = [str hasSuffix:@"}\r\n"];
        //  NSLog(@"%hhd", isSuffix);
        if (isSuffix) {
            
            NSData *data1 = [userData dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&error];
            //    NSLog(@"%ld %@ %@", tag, dic, error);
            userData = @"";
            NSString *str = [dic objectForKey:@"object"];
            //   NSLog(@"%@", str);
            if ([@"true" isEqualToString:str] || [@"TRUE" isEqualToString:str]) {
                [user removeObjectForKey:@"updateType"];
                myDelegate.user = user;
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                NSString *password = aNewText.text;
                [defaults setObject:password forKey:@"password"];
                [defaults synchronize];
                [self showToast:NSLocalizedString(@"update_success", nil)];
                
            } else {
               
                [user removeObjectForKey:@"updateType"];
                [dataManager showDialog:NSLocalizedString(@"error", nil) content:NSLocalizedString(@"update_failure", nil)];
            }
            
        }
        
        
    }
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

- (void)showToast:(NSString *)message {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    //    HUD.yOffset = 150.0f;
    //    HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end

//
//  EmailSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-25.
//
//

#import "EmailSettingViewController.h"

@interface EmailSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *emailEdit;

@end

@implementation EmailSettingViewController
@synthesize title;
@synthesize emailEdit;
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
    title.text = NSLocalizedString(@"email", nil);
    old_email = @"";
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
    
    if ([user objectForKey:@"email"] == nil || [@"" isEqualToString:[user objectForKey:@"email"]]) {
        emailEdit.placeholder = NSLocalizedString(@"setting_email",nil);
    } else {
        emailEdit.text = [user objectForKey:@"email"];
        old_email = [user objectForKey:@"email"];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirm:(id)sender {
    if ([@"" isEqualToString:emailEdit.text]) {
        [dataManager showDialog:NSLocalizedString(@"error", nil) content:NSLocalizedString(@"email_empty", nil)];
        return;
    }
    if ([emailEdit.text isEqualToString:old_email]) {
        [dataManager showDialog:NSLocalizedString(@"info", nil) content:NSLocalizedString(@"email_no_change", nil)];
        return;
    }
    if (![self isEmail:emailEdit.text]) {
        [dataManager showDialog:NSLocalizedString(@"error", nil) content:NSLocalizedString(@"email_error", nil)];
        return;

    }
    [user setObject:emailEdit.text forKey:@"email"];
    [user setObject:@"EMAIL" forKey:@"updateType"];
    [self updateUser];
    
}

- (BOOL)isEmail:(NSString *)email {
    if (email == nil || [@"" isEqualToString:email]) {
        return false;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
                [delegate passValue:@""];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                [user setObject:old_email forKey:@"email"];
                [user removeObjectForKey:@"updateType"];
                [dataManager showDialog:NSLocalizedString(@"error", nil) content:NSLocalizedString(@"update_failure", nil)];
            }
            
        }
        
        
    }
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end

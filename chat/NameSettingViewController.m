//
//  NameSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-23.
//
//

#import "NameSettingViewController.h"

@interface NameSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *nameEdit;

@property (weak, nonatomic) IBOutlet UILabel *comment;

@end

@implementation NameSettingViewController
@synthesize title;
@synthesize nameEdit;
@synthesize comment;
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
    title.text = NSLocalizedString(@"name", nil);
    comment.text = NSLocalizedString(@"name_hint", nil);
    old_name = @"";
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
    
    if ([user objectForKey:@"name"] == nil || [@"" isEqualToString:[user objectForKey:@"name"]]) {
        nameEdit.placeholder = NSLocalizedString(@"setting_name",nil);
    } else {
        nameEdit.text = [user objectForKey:@"name"];
        old_name = [user objectForKey:@"name"];
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
- (IBAction)confirm:(id)sender {
    if ([@"" isEqualToString:nameEdit.text]) {
        [dataManager showDialog:NSLocalizedString(@"error", nil) content:NSLocalizedString(@"name_empty", nil)];
        return;
    }
    if ([nameEdit.text isEqualToString:old_name]) {
        [dataManager showDialog:NSLocalizedString(@"info", nil) content:NSLocalizedString(@"name_no_change", nil)];
        return;
    }
    [user setObject:nameEdit.text forKey:@"name"];
    [user setObject:@"NAME" forKey:@"updateType"];
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
                [delegate passValue:@""];
                [self dismissViewControllerAnimated:YES completion:nil];
                 
            } else {
                [user setObject:old_name forKey:@"name"];
                [user removeObjectForKey:@"updateType"];
                [dataManager showDialog:NSLocalizedString(@"error", nil) content:NSLocalizedString(@"update_failure", nil)];
            }
            
        }
        
        
    }
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

@end

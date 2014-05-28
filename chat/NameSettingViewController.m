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
     myDelegate = [[UIApplication sharedApplication] delegate];
    title.text = [myDelegate.bundle localizedStringForKey:@"name" value:nil table:@"language"];
    comment.text = [myDelegate.bundle localizedStringForKey:@"name_hint" value:nil table:@"language"];
    old_name = @"";
    userData = @"";
    
   
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    user = myDelegate.user;
    
    if ([user objectForKey:@"name"] == nil || [@"" isEqualToString:[user objectForKey:@"name"]]) {
        nameEdit.placeholder = [myDelegate.bundle localizedStringForKey:@"setting_name" value:nil table:@"language"];
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
        [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"error" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"name_empty" value:nil table:@"language"]];
        return;
    }
    if ([nameEdit.text isEqualToString:old_name]) {
        [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"info" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"name_no_change" value:nil table:@"language"]];
        return;
    }
    [user setObject:nameEdit.text forKey:@"name"];
    [user setObject:@"NAME" forKey:@"updateType"];
    [self updateUser];
    
}

- (void)updateUser {
   // [self showHubLoading:[myDelegate.bundle localizedStringForKey:@"logging_out" value:nil table:@"language"]];
    
    type = @"UPDATEUSER";
    NSString *json;
    NSString *temp = @"\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = @"{\"type\":\"UPDATEUSER\",\"object\":\"";
    NSString *mapString = [myDelegate toJSONData:user];
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
                [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"error" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"update_failure" value:nil table:@"language"]];
            }
            
        }
        
        
    }
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

@end

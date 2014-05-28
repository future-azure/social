//
//  PrivacyViewController.m
//  chat
//
//  Created by brightvision on 14-5-26.
//
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *findByF;
@property (weak, nonatomic) IBOutlet UIButton *findByT;
@property (weak, nonatomic) IBOutlet UIButton *findById;
@property (weak, nonatomic) IBOutlet UIButton *findByP;
@property (weak, nonatomic) IBOutlet UIButton *moments;
@property (weak, nonatomic) IBOutlet UISwitch *findByFCheck;
@property (weak, nonatomic) IBOutlet UISwitch *findByTCheck;
@property (weak, nonatomic) IBOutlet UISwitch *findByIdCheck;
@property (weak, nonatomic) IBOutlet UISwitch *findByPCheck;

@end

@implementation PrivacyViewController
@synthesize title;
@synthesize findByF;
@synthesize findByFCheck;
@synthesize findById;
@synthesize findByIdCheck;
@synthesize findByP;
@synthesize findByPCheck;
@synthesize findByT;
@synthesize findByTCheck;
@synthesize moments;

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

    title.text = [myDelegate.bundle localizedStringForKey:@"privacy" value:nil table:@"language"];
    
    [findByF setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"find_by_f" value:nil table:@"language"]] forState:UIControlStateNormal];
    [findByT setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"find_by_t" value:nil table:@"language"]] forState:UIControlStateNormal];
    [findByP setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"find_by_p" value:nil table:@"language"]] forState:UIControlStateNormal];
    [findById setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"find_by_id" value:nil table:@"language"]] forState:UIControlStateNormal];
    
    [moments setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"moments" value:nil table:@"language"]] forState:UIControlStateNormal];
       if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    user = [myDelegate.user mutableCopy];
    
    settingDB = myDelegate.settingDB;
    setting = myDelegate.setting;
    
    userData = @"";
    
    [findByFCheck setOn:[user[@"findByFacebook"] intValue] == 1 ? true : false];
    [findByTCheck setOn:[user[@"findByTwitter"] intValue] == 1 ? true : false];

    [findByPCheck setOn:[user[@"findByPhone"] intValue] == 1 ? true : false];

    [findByIdCheck setOn:[user[@"findById"] intValue] == 1 ? true : false];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)findByFClick:(id)sender {
    if (user[@"facebookId"] != nil || [@"" isEqualToString:user[@"facebookId"]]) {
        [findByFCheck setOn:findByFCheck.isOn ? false : true];
        [user setObject:findByFCheck.isOn ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0] forKey:@"findByFacebook"];
        [user setObject:@"FINDBYF" forKey:@"updateType"];
        [self updateUser];
    } else {
        [myDelegate showDialog:@"info" content:[myDelegate.bundle localizedStringForKey:@"facebook_setting" value:nil table:@"language"]];
        [findByFCheck setOn:false];
    }
}
- (IBAction)findByTClick:(id)sender {
    if (user[@"twitterId"] != nil || [@"" isEqualToString:user[@"twitterId"]]) {
        [findByTCheck setOn:findByTCheck.isOn ? false : true];
        [user setObject:findByTCheck.isOn ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0] forKey:@"findByTwitter"];
        [user setObject:@"FINDBYT" forKey:@"updateType"];
        [self updateUser];
    } else {
        [myDelegate showDialog:@"info" content:[myDelegate.bundle localizedStringForKey:@"twitter_setting" value:nil table:@"language"]];
        [findByTCheck setOn:false];
    }

}
- (IBAction)findByIdClick:(id)sender {
    [findByIdCheck setOn:findByIdCheck.isOn ? false : true];
    [user setObject:findByIdCheck.isOn ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0] forKey:@"findById"];
    [user setObject:@"FINDBYID" forKey:@"updateType"];
    [self updateUser];

}
- (IBAction)findByPClick:(id)sender {
    [findByPCheck setOn:findByPCheck.isOn ? false : true];
    [user setObject:findByPCheck.isOn ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0] forKey:@"findByPhone"];
    [user setObject:@"FINDBYPHONE" forKey:@"updateType"];
    [self updateUser];
}
- (IBAction)momentClick:(id)sender {
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
                
            } else {
                [user removeObjectForKey:@"updateType"];
                [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"error" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"update_failure" value:nil table:@"language"]];
            }
            
        }
        
        
    }
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}


@end

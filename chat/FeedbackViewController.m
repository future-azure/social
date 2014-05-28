//
//  FeedbackViewController.m
//  chat
//
//  Created by brightvision on 14-5-26.
//
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *content;

@end

@implementation FeedbackViewController
@synthesize title;
@synthesize content;

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
    title.text = [myDelegate.bundle localizedStringForKey:@"feedback_title" value:nil table:@"language"];
    
      userData = @"";
    
   // myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
}

- (void)updateFeedback {
    // [self showHubLoading:[myDelegate.bundle localizedStringForKey:@"logging_out" value:nil table:@"language"]];
    
    type = @"FEEDBACK";
    NSString *json = @"{\"type\":\"FEEDBACK\",\"object\":\"";
    NSString *temp = @"\",\"toUser\":0,\"fromUser\":";
    NSString *end = @"}\r\n";
    
    
    json = [json stringByAppendingFormat:@"%@%@%d%@",content.text, temp, [[myDelegate.user objectForKey:@"id"] intValue], end];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
  
    
    
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    
    if([@"FEEDBACK" isEqualToString:type]) {
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
                
                [self showToast:[myDelegate.bundle localizedStringForKey:@"feedback_success" value:nil table:@"language"]];
                
            } else {
                
                [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"error" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"feedback_error" value:nil table:@"language"]];
            }
            
        }
        
        
    }
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirm:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)back:(id)sender {
    if ([@"" isEqualToString:[content.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
        [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"info" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"content_empty" value:nil table:@"language"]];
        return;
    }
   
    [self updateFeedback];

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

@end

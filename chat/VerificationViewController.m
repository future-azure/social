//
//  VerificationViewController.m
//  chat
//
//  Created by brightvision on 14-5-12.
//
//

#import "VerificationViewController.h"

@interface VerificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *title_show;
@property (weak, nonatomic) IBOutlet UITextField *codeInput;


@end

@implementation VerificationViewController
@synthesize title;
@synthesize title_show;
@synthesize phone_number;
@synthesize country_code;
@synthesize verifiCode;

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
    socket =[[DataManager sharedDataManager]socket];
    socket.delegate = self;
    registerUser = @"";
    
    title.text = NSLocalizedString(@"verification", nil);
    NSLog(@"%@", @"verfication");
    NSString *reg = NSLocalizedString(@"verification_send", nil);
    NSString *blank = @"  ";
    NSString *content = [reg stringByAppendingFormat:@"%@%@%@%@",@"\r\n",country_code, blank, phone_number];
    
    title_show.text = content;
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) register
{
    [self showHubLoading:NSLocalizedString(@"signing_up", nil)];
    type = @"REGISTER";
    NSString *json;
    NSString *temp = @"{\"type\":\"REGISTER\",\"object\":\"{\\\"countryCode\\\":\\\"";
    NSString *temp1 = @"\\\",\\\"phoneNum\\\":\\\"";
    NSString *temp2 = @"\\\",\\\"password\\\":\\\"";
    NSString *temp3 = @"\\\"}\",\"toUser\":0,\"fromUser\":0}\r\n";
    NSString *password =[[DataManager sharedDataManager]md5:verifiCode];

    json = [temp stringByAppendingFormat:@"%@%@%@%@%@%@",country_code, temp1, phone_number, temp2,password, temp3];
    NSLog(@"%@", json);

    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}

- (IBAction)back:(id)sender {
  
        [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)next:(id)sender {
    NSLog(@"next login");
    NSString *code = self.codeInput.text;
    
    if( nil == code || 0 == code.length ||![verifiCode isEqualToString:code] ) {
        [[DataManager sharedDataManager] showDialog:@"error" content:@"verifycode_error"];
        return;
    }
    [self register];
    

}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    
    if([@"REGISTER" isEqualToString:type]) {
        [self closeHubLoading];

        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        registerUser =[registerUser stringByAppendingString:str];
        BOOL isSuffix = [str hasSuffix:@"\"}\r\n"];
      //  NSLog(@"%hhd", isSuffix);
        if (isSuffix) {
            
            NSData *data1 = [registerUser dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
         //   NSLog(@"%ld %@ %@", tag, dic, error);
            
            NSString *str = [dic objectForKey:@"object"];
          //  NSLog(@"%@", str);
            NSData *data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%@", str);
            NSDictionary *user = [NSJSONSerialization JSONObjectWithData:data2
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];

          //  NSLog(@"%@", user);
            int userId = [dic objectForKey:@"user_id"];
            if (userId > -1) {
                //login
            } else {
                [[DataManager sharedDataManager] showDialog:@"error" content:@"register_error"];
                return;

            }
            
        }
    
        
    }
    
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

-(void) showHubLoading:(NSString *)str {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = str;
        
        [HUD show:YES];
        
    
}

-(void) closeHubLoading {
    [HUD removeFromSuperview];
    HUD = nil;
    
    
}



@end

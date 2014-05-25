//
//  PhoneSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-25.
//
//

#import "PhoneSettingViewController.h"

@interface PhoneSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *title_show;
@property (weak, nonatomic) IBOutlet UILabel *countryCode;
@property (weak, nonatomic) IBOutlet UIButton *countryName;

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerBar;
@property (weak, nonatomic) IBOutlet UIView *pickerView;

@end

@implementation PhoneSettingViewController
@synthesize title;
@synthesize title_show;
@synthesize countryCode;
@synthesize countryName;
@synthesize phoneNum;
@synthesize countryPicker;
@synthesize pickerBar;
@synthesize pickerView;

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
    title_show.text = NSLocalizedString(@"reset_select_country", nil);
    title.text =NSLocalizedString(@"reset_phone_num", nil);
    countryData = @"";
    pickerArray = [[NSMutableArray alloc] initWithCapacity:10];
    codeArray = [[NSMutableArray alloc] initWithCapacity:10];
    // 获取手机国家
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSLog(@"Country Code is %@", [currentLocale objectForKey:NSLocaleCountryCode]);
    // 获取手机语言
       myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [dataManager loadCountry];
    socket.delegate = self;
        
    [self loadCountry];
}

- (void) loadCountry
{
    type = @"COUNTRY";
    NSString *json = [NSString stringWithFormat:@"%@%@%@",  @"{\"type\":\"COUNTRY\",\"object\":\"", myDelegate.languageType, @"\",\"toUser\":0,\"fromUser\":0}\r\n"];
    
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}

- (void) checkHasReg
{
    type = @"HASREG";
    NSString *json;
    NSString *code = self.countryCode.text;
    NSString *phone = self.phoneNum.text;
    
    NSString *temp = @"{\"type\":\"HASREG\",\"object\":\"{\\\"countryCode\\\":\\\"";
    NSString *temp1 = @"\\\",\\\"phoneNum\\\":\\\"";
    NSString *temp2 = @"\\\"}\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = [temp stringByAppendingFormat:@"%@%@%@%@",code, temp1, phone, temp2];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}

- (void) register
{
    type = @"SMSREQUEST";
    NSString *json;
    NSString *code = self.countryCode.text;
    NSString *phone = self.phoneNum.text;
    BOOL isPerfix = [phone hasPrefix:@"0"];
    if (isPerfix) {
        phone = [phone substringFromIndex:1];
    }
    
    int vericode = (int)(100000 + (arc4random() % (999999 - 100000 + 1)));
    NSLog(@"%d", vericode);
    veriCode = [NSString stringWithFormat:@"%d",vericode];
    
    NSString *temp = @"{\"type\":\"SMSREQUEST\",\"object\":\"";
    NSString *temp1 = @";Your vertification Code is :  ";
    NSString *temp2 = @"   \\n [From Most App]\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = [temp stringByAppendingFormat:@"%@%@%@%@%@",code, phone, temp1, veriCode, temp2];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    
    if([@"COUNTRY" isEqualToString:type]) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        countryData =[countryData stringByAppendingString:str];
        BOOL isSuffix = [str hasSuffix:@"}\r\n"];
        //  NSLog(@"%hhd", isSuffix);
        if (isSuffix) {
            
            NSData *data1 = [countryData dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&error];
            //    NSLog(@"%ld %@ %@", tag, dic, error);
            
            NSString *str = [dic objectForKey:@"object"];
            //   NSLog(@"%@", str);
            NSData *data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%@", str);
            NSMutableArray *country = [NSJSONSerialization JSONObjectWithData:data2
                                                                      options:NSJSONReadingAllowFragments
                                                                        error:nil];
            //    NSLog(@"%@", country);
            
            //NSMutableArray *countryArray = [dataManager country];
            
            for(id obj in country)
            {
                NSMutableDictionary *cDic = obj;
                //    NSLog(@"%@", [cDic objectForKey:COUNTRYNAME]);
                //   NSLog(@"%@", [cDic objectForKey:COUNTRYCODE]);
                [pickerArray addObject: [cDic objectForKey:COUNTRYNAME]];
                [codeArray addObject: [cDic objectForKey:COUNTRYCODE]];
            }
            //
            //    NSLog(@"pickerArray:%@", pickerArray);
            //    NSLog(@"codeArray:%@", codeArray);
            
            
            
            countryPicker.delegate = self;
            
            countryPicker.dataSource = self;
            
            pickerView.hidden = YES;
            
        }
        
        
    }
    if([@"HASREG" isEqualToString:type]) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&error];
        //  NSLog(@"%ld %@ %@", tag, dic, error);
        
        NSString *str = [dic objectForKey:@"object"];
        //    NSLog(@"%@", str);
        if([@"true" isEqualToString:str]) {
            [dataManager showDialog:@"error" content:@"register_already"];
            return;
        } else {
            NSString *register_confirm =NSLocalizedString(@"register_confirm", nil);
            NSString *code = self.countryCode.text;
            NSString *phone = self.phoneNum.text;
            NSString *blank = @"  ";
            NSString *content = [register_confirm stringByAppendingFormat:@"%@%@%@",code, blank, phone];
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"register_confirm_title", nil) andMessage:content];
            [alertView addButtonWithTitle:NSLocalizedString(@"cancel", nil)
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alertView) {
                                      //   NSLog(@"Cancel Clicked");
                                  }];
            [alertView addButtonWithTitle:NSLocalizedString(@"ok", nil)
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alertView) {
                                      //     NSLog(@"OK Clicked");
                                      [self register];
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
        
    }
    if([@"SMSREQUEST" isEqualToString:type]) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&error];
        //     NSLog(@"%ld %@ %@", tag, dic, error);
        
        NSString *str = [dic objectForKey:@"object"];
        //      NSLog(@"%@", str);
        NSRange range = [str rangeOfString:@"fails"];//判断字符串是否包含
        if (range.length >0)//包含
        {
            [dataManager showDialog:@"error" content:@"send_error"];
            return;
            
        }
        range = [str rangeOfString:@"FAILS"];//判断字符串是否包含
        if (range.length >0)//包含
        {
            [dataManager showDialog:@"error" content:@"send_error"];
            return;
            
        }
        //TODO: 需要恢复
        //        if ([@"" isEqualToString:str])//包含
        //        {
        //            [dataManager showDialog:@"error" content:@"send_error"];
        //            return;
        //
        //        }
        [self performSegueWithIdentifier:@"verificationReset" sender:self];
        
    }
    
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}



- (IBAction)selectStart:(id)sender {
    NSLog(@"start select");
    pickerView.hidden = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)finishSelect:(id)sender {
    NSLog(@"finish select finish");
    NSInteger row = [countryPicker selectedRowInComponent:0];
    
    [self.countryName setTitle:[pickerArray objectAtIndex:row] forState:UIControlStateNormal];
    
    self.countryCode.text = [NSString stringWithFormat:@"%@",[codeArray objectAtIndex:row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"verificationReset"]) //"goView2"是SEGUE连线的标识
    {


        id theSegue = segue.destinationViewController;
        [theSegue setValue:self.phoneNum.text forKey:@"phone_number"];
        [theSegue setValue:self.countryCode.text forKey:@"country_code"];
        [theSegue setValue:veriCode forKey:@"verifiCode"];
        [theSegue setValue:@"true" forKey:@"isReset"];
    }
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)next:(id)sender {
    NSLog(@"next register");
    NSString *code = self.countryCode.text;
    NSString *phone = self.phoneNum.text;
    
    if( nil == code || 0 == code.length) {
        [dataManager showDialog:@"error" content:@"select_country"];
        return;
    }
    if( nil == phone || 0 == phone.length) {
        [dataManager showDialog:@"error" content:@"enter_phone"];
        return;
    }
    [self checkHasReg];

}


@end

//
//  RegisterViewController.m
//  chat
//
//  Created by brightvision on 14-4-21.
//
//

#import "RegisterViewController.h"
#import "UnderLineLabel.h"


@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *top_title_show;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *countryCode;
@property (weak, nonatomic) IBOutlet UITextField *phone_number;
@property (weak, nonatomic) IBOutlet UILabel *agree_to;
@property (weak, nonatomic) IBOutlet UIPickerView *countrySelect;
@property (weak, nonatomic) IBOutlet UIToolbar *buttonSelect;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishSelect;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *countyName;

@end



@implementation RegisterViewController


@synthesize top_title_show;
@synthesize countrySelect;
@synthesize title;
@synthesize countryCode;
@synthesize phone_number;
@synthesize agree_to;
@synthesize countyName;
@synthesize finishSelect;
@synthesize buttonSelect;
@synthesize selectView;


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
    top_title_show.text = [myDelegate.bundle localizedStringForKey:@"select_country" value:nil table:@"language"];
    title.text =[myDelegate.bundle localizedStringForKey:@"phone_num" value:nil table:@"language"];
    countryData = @"";
    pickerArray = [[NSMutableArray alloc] initWithCapacity:10];
    codeArray = [[NSMutableArray alloc] initWithCapacity:10];
    // 获取手机国家
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSLog(@"Country Code is %@", [currentLocale objectForKey:NSLocaleCountryCode]);
    // 获取手机语言
  //  NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [dataManager loadCountry];
    socket.delegate = self;
    [self loadCountry];
    
    //         NSError *error = nil;
    
    
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
    NSString *phone = self.phone_number.text;
    
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
    NSString *phone = self.phone_number.text;
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
            
            
            
            UnderLineLabel *label = [[UnderLineLabel alloc] initWithFrame:CGRectMake(agree_to.frame.origin.x, agree_to.frame.origin.y, 141, 18)];
            
            //自定义下划线label
            [label setBackgroundColor:[UIColor clearColor]];
            // [label setBackgroundColor:[UIColor yellowColor]];
            [label setTextColor:[UIColor orangeColor]];
            label.highlightedColor = [UIColor orangeColor];
            label.shouldUnderline = YES;
            NSString *str1 = [myDelegate.bundle localizedStringForKey:@"terms" value:nil table:@"language"];
            
            
            [label setText:str1 andCenter:CGPointMake(126 + 75, agree_to.frame.origin.y + 9)];
            [label addTarget:self action:@selector(labelClicked)];
            
            [self.view addSubview:label];
            
            
            //自定义checkbox
            termsCheckBox = [UIButton buttonWithType:UIButtonTypeCustom];
            
            
            CGRect checkboxRect = CGRectMake(34,agree_to.frame.origin.y,18,18);
            
            [termsCheckBox setFrame:checkboxRect];
            
            
            
            [termsCheckBox setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
            
            [termsCheckBox setImage:[UIImage imageNamed:@"checkbox_selected.png"] forState:UIControlStateSelected];
            
            
            
            [termsCheckBox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:termsCheckBox];
            
            countrySelect.delegate = self;
            
            countrySelect.dataSource = self;
            
            selectView.hidden = YES;
            
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
            [myDelegate showDialog:@"error" content:@"register_already"];
            return;
        } else {
            NSString *register_confirm =[myDelegate.bundle localizedStringForKey:@"register_confirm" value:nil table:@"language"];
            NSString *code = self.countryCode.text;
            NSString *phone = self.phone_number.text;
            NSString *blank = @"  ";
            NSString *content = [register_confirm stringByAppendingFormat:@"%@%@%@",code, blank, phone];
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:[myDelegate.bundle localizedStringForKey:@"register_confirm_title" value:nil table:@"language"] andMessage:content];
            [alertView addButtonWithTitle:[myDelegate.bundle localizedStringForKey:@"cancel" value:nil table:@"language"]
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alertView) {
                                   //   NSLog(@"Cancel Clicked");
                                  }];
            [alertView addButtonWithTitle:[myDelegate.bundle localizedStringForKey:@"ok" value:nil table:@"language"]
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
            [myDelegate showDialog:@"error" content:@"send_error"];
            return;
            
        }
        range = [str rangeOfString:@"FAILS"];//判断字符串是否包含
        if (range.length >0)//包含
        {
            [myDelegate showDialog:@"error" content:@"send_error"];
            return;
            
        }
       //TODO: 需要恢复
//        if ([@"" isEqualToString:str])//包含
//        {
//            [myDelegate showDialog:@"error" content:@"send_error"];
//            return;
//            
//        }
        [self performSegueWithIdentifier:@"verification" sender:self];
        
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
    selectView.hidden = NO;
}


-(void)checkboxClick:(UIButton *)btn

{
    
    btn.selected = !btn.selected;
    
}

-(bool)getSelect:(UIButton *)btn

{
    return btn.selected;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)labelClicked
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self performSegueWithIdentifier:@"termsView" sender:self];
    NSLog(@"end");
    
}

- (IBAction)finishButton:(id)sender {
    NSLog(@"finish select finish");
    NSInteger row = [countrySelect selectedRowInComponent:0];
    
    [self.countyName setTitle:[pickerArray objectAtIndex:row] forState:UIControlStateNormal];
    
    self.countryCode.text = [NSString stringWithFormat:@"%@",[codeArray objectAtIndex:row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"verification"]) //"goView2"是SEGUE连线的标识
    {
        id theSegue = segue.destinationViewController;
        [theSegue setValue:self.phone_number.text forKey:@"phone_number"];
        [theSegue setValue:self.countryCode.text forKey:@"country_code"];
        [theSegue setValue:veriCode forKey:@"verifiCode"];
    }
}

- (IBAction)next:(id)sender {
    NSLog(@"next register");
    NSString *code = self.countryCode.text;
    NSString *phone = self.phone_number.text;
    
    if( nil == code || 0 == code.length) {
        [myDelegate showDialog:@"error" content:@"select_country"];
        return;
    }
    if( nil == phone || 0 == phone.length) {
        [myDelegate showDialog:@"error" content:@"enter_phone"];
        return;
    }
    NSLog(@"%hhd", termsCheckBox.selected);
    if(termsCheckBox.selected == 0) {
        [myDelegate showDialog:@"error" content:@"agree_to_register"];
        return;
    }
    [self checkHasReg];
    
   
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

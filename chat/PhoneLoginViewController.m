//
//  PhoneLoginViewController.m
//  chat
//
//  Created by brightvision on 14-5-22.
//
//

#import "PhoneLoginViewController.h"

@interface PhoneLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *title_show;
@property (weak, nonatomic) IBOutlet UIButton *countryName;
@property (weak, nonatomic) IBOutlet UILabel *countryCode;
@property (weak, nonatomic) IBOutlet UIToolbar *pickerBar;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIPickerView *countryPicker;
@property (weak, nonatomic) IBOutlet UIView *selectView;

@end

@implementation PhoneLoginViewController

@synthesize delegate;
@synthesize title;
@synthesize title_show;
@synthesize countryPicker;
@synthesize countryName;
@synthesize countryCode;
@synthesize phoneNum;
@synthesize selectView;
@synthesize pickerBar;

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
    
    title_show.text = [myDelegate.bundle localizedStringForKey:@"select_country" value:nil table:@"language"];
    title.text =[myDelegate.bundle localizedStringForKey:@"phone_num" value:nil table:@"language"];
    countryData = @"";
    pickerArray = [[NSMutableArray alloc] initWithCapacity:10];
    codeArray = [[NSMutableArray alloc] initWithCapacity:10];
    // 获取手机国家
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSLog(@"Country Code is %@", [currentLocale objectForKey:NSLocaleCountryCode]);
    // 获取手机语言
    NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
   
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
    NSString *json;
    json = @"{\"type\":\"COUNTRY\",\"object\":\"en\",\"toUser\":0,\"fromUser\":0}\r\n";
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            countryData = @"";
            
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
            
            selectView.hidden = YES;
            
        }
        
        
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


-(bool)getSelect:(UIButton *)btn

{
    return btn.selected;
    
}


- (IBAction)finishButton:(id)sender {
    NSLog(@"finish select finish");
    NSInteger row = [countryPicker selectedRowInComponent:0];
    
    [self.countryName setTitle:[pickerArray objectAtIndex:row] forState:UIControlStateNormal];
    
    self.countryCode.text = [NSString stringWithFormat:@"%@",[codeArray objectAtIndex:row]];
}



- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)next:(id)sender {
    NSLog(@"next register");
    NSString *code = self.countryCode.text;
    NSString *phone = self.phoneNum.text;
    
    if( nil == code || 0 == code.length) {
        [myDelegate showDialog:@"error" content:@"select_country"];
        return;
    }
    if( nil == phone || 0 == phone.length) {
        [myDelegate showDialog:@"error" content:@"enter_phone"];
        return;
    }
    [delegate passValue:phone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

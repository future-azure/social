//
//  TimeSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-27.
//
//

#import "TimeSettingViewController.h"

@interface TimeSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *wholeDay;
@property (weak, nonatomic) IBOutlet UIButton *begin;
@property (weak, nonatomic) IBOutlet UISwitch *whole;
@property (weak, nonatomic) IBOutlet UIButton *end;
@property (weak, nonatomic) IBOutlet UILabel *beginTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *ok;
@property (weak, nonatomic) IBOutlet UILabel *timeSetTitle;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *timeSetView;

@end

@implementation TimeSettingViewController
@synthesize title;
@synthesize whole;
@synthesize wholeDay;
@synthesize begin;
@synthesize end;
@synthesize beginTime;
@synthesize endTime;
@synthesize cancel;
@synthesize ok;
@synthesize timeSetTitle;
@synthesize datePicker;
@synthesize timeSetView;

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
    title.text = [myDelegate.bundle localizedStringForKey:@"time" value:nil table:@"language"];
    
    [wholeDay setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"whole_day" value:nil table:@"language"]] forState:UIControlStateNormal];
    [begin setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"begin_time" value:nil table:@"language"]] forState:UIControlStateNormal];
    [end setTitle:[@"    " stringByAppendingString: [myDelegate.bundle localizedStringForKey:@"end_time" value:nil table:@"language"]] forState:UIControlStateNormal];
    [cancel setTitle:[myDelegate.bundle localizedStringForKey:@"cancel" value:nil table:@"language"] forState:UIControlStateNormal];
    [ok setTitle:[myDelegate.bundle localizedStringForKey:@"ok" value:nil table:@"language"] forState:UIControlStateNormal];
    
    timeSetTitle.text = [myDelegate.bundle localizedStringForKey:@"time_set" value:nil table:@"language"];
    timeSetView.hidden = YES;
    
    
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    user = myDelegate.user;
    
    settingDB = myDelegate.settingDB;
    setting = myDelegate.setting;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSHourCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];

    int hour = [comps hour];
    NSString *btime;
    NSString *etime;
    if (hour < 10) {
        btime = [@"0" stringByAppendingFormat:@"%d:00" ,hour];
    }else {
        btime = [NSString stringWithFormat:@"%d:00", hour];
    }
    hour += 1;
    if (hour < 10) {
        etime = [@"0" stringByAppendingFormat:@"%d:00" ,hour];
    }else if (hour > 23){
        etime = @"00:00";
    } else {
         etime = [NSString stringWithFormat:@"%d:00", hour];
    }
    beginTime.text = btime;
    endTime.text = etime;
    
    if ([setting[@"whole_day"] intValue] == 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //this is the sqlite's format
        
        NSDate *bDate = [formatter dateFromString:setting[@"begin_time"]];
        NSDate *eDate = [formatter dateFromString:setting[@"end_time"]];
        [formatter setDateFormat:@"HH:mm"]; //this is the sqlite's format
        beginTime.text = [formatter stringFromDate:bDate];
        endTime.text = [formatter stringFromDate:eDate];
         [whole setOn:false];
        begin.hidden = NO;
        end.hidden = NO;
        beginTime.hidden = NO;
        endTime.hidden = NO;
    }
    
    if ([setting[@"whole_day"] intValue] == 1) {
        [whole setOn:true];
        begin.hidden = YES;
        end.hidden = YES;
        beginTime.hidden = YES;
        endTime.hidden = YES;
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

- (IBAction)wholeDayClick:(id)sender {
    if (whole.isOn) {
        [whole setOn:false];
        begin.hidden = NO;
        end.hidden = NO;
        beginTime.hidden = NO;
        endTime.hidden = NO;
        [setting setObject:[NSNumber numberWithInt:0] forKey:@"whole_day"];
    } else {
        [whole setOn:true];
        begin.hidden = YES;
        end.hidden = YES;
        beginTime.hidden = YES;
        endTime.hidden = YES;
        [setting setObject:[NSNumber numberWithInt:1] forKey:@"whole_day"];
    }
}

- (void) updateSetting {
    [settingDB saveSetting:[[myDelegate.user objectForKey:@"id"] intValue] userSetting:setting];
}


- (IBAction)beginClick:(id)sender {
    isBegin = true;
    timeSetView.hidden = NO;
    
}
- (IBAction)endClick:(id)sender {
    isBegin = false;
    timeSetView.hidden = NO;
}

- (IBAction)cancelClick:(id)sender {
    timeSetView.hidden = YES;
    
}

- (IBAction)okClick:(id)sender {
    NSDate *select = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *time =  [dateFormatter stringFromDate:select];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"]; //this is the sqlite's format
    NSDate *date =[NSDate date];
    NSString *d = [formatter stringFromDate:date];
    NSString *timer = [NSString stringWithFormat:@"%@ %@:00", d, time];
   // [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (isBegin) {
        beginTime.text = time;
        
        [setting setObject:timer forKey:@"begin_time"];
    } else {
        endTime.text = time;
        [setting setObject:timer forKey:@"end_time"];
    }
    timeSetView.hidden = YES;
    [self updateSetting];
}

@end

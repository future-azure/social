//
//  RegisterViewController.m
//  chat
//
//  Created by brightvision on 14-4-21.
//
//

#import "RegisterViewController.h"
#import "UnderLineLabel.h"
#import "SIAlertView.h"

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
    
    top_title_show.text = NSLocalizedString(@"select_country", nil);
    title.text =NSLocalizedString(@"phone_num", nil);
    
    //NSMutableArray *newArray = [[NSMutableArray alloc] init];
//    NSArray *oldArray = [NSArray arrayWithObjects:
//                         @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",nil];
//    NSLog(@"oldArray:%@",oldArray);
//    
//    for(id obj in oldArray)
//    {
//        [newArray addObject: obj];
//    }
//    
//    NSArray *country = [[DataManager sharedDataManager] loadCountry] ;
//    [(UILabel *) [cell viewWithTag:TAG_USER] setText:[[moment objectForKey:USER] objectForKey:NAME]];
//    [(UILabel *) [cell viewWithTag:TAG_CONTEXT] setText:[moment objectForKey:CONTEXT]];
//    [(UILabel *) [cell viewWithTag:TAG_DATE] setText:[moment objectForKey:CREATE_TIME]];
//    [(UILabel *) [cell viewWithTag:TAG_LIKE] setText:[[moment objectForKey:LIKE_CNT] stringValue]];
//    [(UILabel *) [cell viewWithTag:TAG_COMMENT] setText:[[moment objectForKey:COMMENT_CNT] stringValue]];
//    return cell;

    UnderLineLabel *label = [[UnderLineLabel alloc] initWithFrame:CGRectMake(agree_to.frame.origin.x, agree_to.frame.origin.y, 141, 18)];

    //自定义下划线label
    [label setBackgroundColor:[UIColor clearColor]];
    // [label setBackgroundColor:[UIColor yellowColor]];
    [label setTextColor:[UIColor orangeColor]];
    label.highlightedColor = [UIColor orangeColor];
    label.shouldUnderline = YES;
    NSString *str = NSLocalizedString(@"terms", nil);
    
   
    [label setText:str andCenter:CGPointMake(126 + 75, agree_to.frame.origin.y + 9)];
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
    
    pickerArray = [NSArray arrayWithObjects:@"86   中国",@"381  南斯拉夫",@"27   南非",@"263  津巴布韦", nil];
    codeArray = [NSArray arrayWithObjects:@"86",@"381",@"27",@"263", nil];
 
    
    countrySelect.delegate = self;

    countrySelect.dataSource = self;

    selectView.hidden = YES;
    

  

    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)labelClicked
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self performSegueWithIdentifier:@"termsView" sender:self];
    NSLog(@"end");

}

- (IBAction)finishButton:(id)sender {
    NSLog(@"finish select finish");
    NSLog(@"finish select input");
    NSInteger row = [countrySelect selectedRowInComponent:0];

    [self.countyName setTitle:[pickerArray objectAtIndex:row] forState:UIControlStateNormal];
    
    self.countryCode.text = [codeArray objectAtIndex:row];
}

- (IBAction)next:(id)sender {
    NSLog(@"next register");
    NSString *code = self.countryCode.text;
    NSString *phone = self.phone_number.text;
    
    if( nil == code || 0 == code.length) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) andMessage:NSLocalizedString(@"select_country", nil)];
        [alertView addButtonWithTitle:NSLocalizedString(@"ok", nil)
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"OK Clicked");
                                  
                              }];
        alertView.titleColor = [UIColor blueColor];
        alertView.cornerRadius = 10;
        alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        
        alertView.willShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willShowHandler2", alertView);
        };
        alertView.didShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, didShowHandler2", alertView);
        };
        alertView.willDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willDismissHandler2", alertView);
        };
        alertView.didDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, didDismissHandler2", alertView);
        };
        
        [alertView show];
        
        return;
    }
    if( nil == phone || 0 == phone.length) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) andMessage:NSLocalizedString(@"enter_phone", nil)];
        [alertView addButtonWithTitle:NSLocalizedString(@"ok", nil)
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"OK Clicked");
                                  
                              }];
        alertView.titleColor = [UIColor blueColor];
        alertView.cornerRadius = 10;
        alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        
        alertView.willShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willShowHandler2", alertView);
        };
        alertView.didShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, didShowHandler2", alertView);
        };
        alertView.willDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willDismissHandler2", alertView);
        };
        alertView.didDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, didDismissHandler2", alertView);
        };
        
        [alertView show];
        return;
    }
    NSLog(@"%hhd", termsCheckBox.selected);
    if(termsCheckBox.selected == 0) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) andMessage:NSLocalizedString(@"agree_to_register", nil)];
        [alertView addButtonWithTitle:NSLocalizedString(@"ok", nil)                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  NSLog(@"OK Clicked");
                                  
                              }];
        alertView.titleColor = [UIColor blueColor];
        alertView.cornerRadius = 10;
        alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        
        alertView.willShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willShowHandler2", alertView);
        };
        alertView.didShowHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, didShowHandler2", alertView);
        };
        alertView.willDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, willDismissHandler2", alertView);
        };
        alertView.didDismissHandler = ^(SIAlertView *alertView) {
            NSLog(@"%@, didDismissHandler2", alertView);
        };
        
        [alertView show];
        return;
    }
    
    
    [self performSegueWithIdentifier:@"verification" sender:self];
}

@end

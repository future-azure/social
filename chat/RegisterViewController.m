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
@property (weak, nonatomic) IBOutlet UIPickerView *countrySelect;
@property (weak, nonatomic) IBOutlet UILabel *countryCode;
@property (weak, nonatomic) IBOutlet UITextField *phone_number;

@end



@implementation RegisterViewController

@synthesize top_title_show;
@synthesize countrySelect;
@synthesize title;
@synthesize countryCode;
@synthesize phone_number;

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
    UnderLineLabel *label = [[UnderLineLabel alloc] initWithFrame:CGRectMake(149, 417, 141, 18)];
    [label setBackgroundColor:[UIColor clearColor]];
    // [label setBackgroundColor:[UIColor yellowColor]];
    [label setTextColor:[UIColor orangeColor]];
    label.highlightedColor = [UIColor orangeColor];
    label.shouldUnderline = YES;
    NSString *str = NSLocalizedString(@"terms", nil);
    
    
    [label setText:str andCenter:CGPointMake(200, 240)];
    [label addTarget:self action:@selector(labelClicked)];
    [self.view addSubview:label];
  

    // Do any additional setup after loading the view.
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

@end

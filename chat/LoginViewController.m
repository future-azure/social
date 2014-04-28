//
//  LoginViewController.m
//  chat
//
//  Created by Kenny on 2014/04/11.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController

@synthesize scrollView;
@synthesize textField;
@synthesize switchAccount;
@synthesize signUp;


- (IBAction)signUp:(id)sender {
}

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
    // Do any additional setup after loading the view.

    textField.delegate = self;
   [switchAccount setTitle:NSLocalizedString(@"switch_account", nil) forState:UIControlStateNormal];
    [signUp setTitle:NSLocalizedString(@"sign_up", nil) forState:UIControlStateNormal];
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

- (void)textFieldDidBeginEditing:(UITextField *)sender
{
    [self.scrollView setContentOffset:CGPointMake(0, sender.frame.origin.y / 3) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)sender
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end

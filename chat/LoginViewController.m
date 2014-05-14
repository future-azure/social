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
    
    loginData = @"";
    socket =[[DataManager sharedDataManager]socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
   

}

-(void) login {
    
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
- (IBAction)login:(id)sender {
     
     [self login];
}

- (void)textFieldDidBeginEditing:(UITextField *)sender
{
    [self.scrollView setContentOffset:CGPointMake(0, sender.frame.origin.y / 3) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)sender
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)switchAccount:(id)sender {
    actionSheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"1", @"2", @"3", nil];
    
    actionSheet.buttonResponse = IBActionSheetButtonResponseFadesOnPress;
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:0];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:0];
    [actionSheet setFont:[UIFont fontWithName:@"1" size:22] forButtonAtIndex:0];
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:1];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:1];
    [actionSheet setFont:[UIFont fontWithName:@"2" size:22] forButtonAtIndex:1];
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:2];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:2];
    [actionSheet setFont:[UIFont fontWithName:@"3" size:22] forButtonAtIndex:2];
    
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:3];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forButtonAtIndex:3];
    [actionSheet setFont:[UIFont fontWithName:@"cancel" size:22] forButtonAtIndex:3];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"confirm");
    }else if (buttonIndex == 1) {
        NSLog(@"confirm1");
    }else if(buttonIndex == 2) {
        NSLog(@"confirm2");
    }else if(buttonIndex == 3) {
        NSLog(@"cancel");

    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//   
//        for(id aview in actionSheet.subviews)
//        {
//            if([aview isKindOfClass:[UIButton class]])
//            {
//                if(![((UIButton*)aview).titleLabel.text isEqualToString:@"cancel"])//判断找到 对应 button
//                {
//                    ((UIButton*)aview).backgroundColor = [UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1];
//                    
//                    
//                } else {
//                    ((UIButton*)aview).backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
//                }
//            }
//        }
//    
//}

@end

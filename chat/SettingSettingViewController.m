//
//  SettingSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-25.
//
//

#import "SettingSettingViewController.h"

@interface SettingSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;


@end

@implementation SettingSettingViewController
@synthesize title;

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
    title.text = [myDelegate.bundle localizedStringForKey:@"setting" value:nil table:@"language"];
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
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

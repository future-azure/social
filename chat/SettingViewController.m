//
//  SettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-6.
//
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *profile;

@end



@implementation SettingViewController

@synthesize profile;
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
    title.text =NSLocalizedString(@"me", nil);

    // Do any additional setup after loading the view.
    UIImage *image=[UIImage imageNamed:@"profile_img.png"];
    [self.profile setImage:image];

    [profile.layer setCornerRadius:CGRectGetHeight([profile bounds]) / 2];
  //  profile.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    profile.layer.masksToBounds = YES;
    profile.layer.borderWidth = 2;
    profile.layer.borderColor = [[UIColor whiteColor] CGColor];
 //   profile.layer.cornerRadius = 50;
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

@end

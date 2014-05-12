//
//  VerificationViewController.m
//  chat
//
//  Created by brightvision on 14-5-12.
//
//

#import "VerificationViewController.h"

@interface VerificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *title_show;

@end

@implementation VerificationViewController
@synthesize title;
@synthesize title_show;
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
    title.text = NSLocalizedString(@"select_country", nil);
 NSLog(@"%@", @"verfication");
     title_show.text = [NSLocalizedString(@"register_confirm", nil) stringByAppendingString:phone_number];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:@"phoneNumber" object:nil];
    
   
;
    
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

- (IBAction)back:(id)sender {
  
        [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end

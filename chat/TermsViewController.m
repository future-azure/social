//
//  TermsViewController.m
//  chat
//
//  Created by brightvision on 14-4-21.
//
//

#import "TermsViewController.h"

@interface TermsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation TermsViewController
@synthesize myWebView;
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
    NSLog(@"termsLoad");
  //  NSString *path = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
  //  [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
    
    title.text = [myDelegate.bundle localizedStringForKey:@"terms" value:nil table:@"language"];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    [myWebView loadHTMLString:htmlString baseURL:baseURL];
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

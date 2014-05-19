//
//  HomeViewController.m
//  chat
//
//  Created by Kenny on 2014/04/14.
//
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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

    UITabBar *tabBar = self.tabBar;
    [tabBar setBackgroundImage:[DataManager imageWithColor:[UIColor darkGrayColor] size:tabBar.bounds.size]];
    CGSize tabBarItemSize = CGSizeMake(tabBar.bounds.size.width / tabBar.items.count, tabBar.bounds.size.height);
    [tabBar setSelectionIndicatorImage:[DataManager imageWithColor:[UIColor orangeColor] size:tabBarItemSize]];

    NSArray *titles = [NSArray arrayWithObjects:@"Moments", @"Things", @"Chats", @"Contacts", @"Me", nil];
    for (int i = 0; i < tabBar.items.count; i++) {
        UITabBarItem *item = [tabBar.items objectAtIndex:i];
        NSString *title = [titles objectAtIndex:i];
        [item setTitle:title];

        UIImage *image =[UIImage imageNamed:title];
        image = [DataManager resize:image
                               rect:CGRectMake(0, 0, tabBarItemSize.width * 0.5, tabBarItemSize.height * 0.7)];
        [item setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select", title]];
        image = [DataManager resize:image
                               rect:CGRectMake(0, 0, tabBarItemSize.width * 0.5, tabBarItemSize.height * 0.7)];
        [item setSelectedImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        [item setTitleTextAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      [UIFont fontWithName:@"ArialHebrew" size:12], NSFontAttributeName,
                                      nil] forState:UIControlStateNormal];
        [item setTitleTextAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor darkGrayColor], NSForegroundColorAttributeName,
                                      [UIFont fontWithName:@"ArialHebrew" size:12], NSFontAttributeName,
                                      nil] forState:UIControlStateSelected];
    }
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

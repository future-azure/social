//
//  ThingsPageViewController.m
//  chat
//
//  Created by Kenny on 2014/04/18.
//
//

#import "ThingsPageViewController.h"

#define THINGS_TABLE_VIEW_CONTROLLER @"ThingsTableViewController"
#define THINGS_COLLECTION_VIEW_CONTROLLER @"ThingsCollectionViewController"

@interface ThingsPageViewController ()

@end

@implementation ThingsPageViewController

@synthesize thingsTableViewController;
@synthesize thingsCollectionViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    self.delegate = self;
    
    thingsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:THINGS_TABLE_VIEW_CONTROLLER];
    thingsCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:THINGS_COLLECTION_VIEW_CONTROLLER];
    [self setViewControllers:[NSArray arrayWithObject:thingsTableViewController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UITableViewController class]]) {
        return nil;
    } else {
        return thingsTableViewController;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UICollectionViewController class]]) {
        return nil;
    } else {
        return thingsCollectionViewController;
    }
}

@end

//
//  ThingsViewController.m
//  chat
//
//  Created by Kenny on 2014/04/12.
//
//

#import "ThingsViewController.h"

#define THINGS_CELL_LIST @"ThingsCellList"
#define THINGS_CELL_WATERFALL @"ThingsCellWaterfall"

#define TAG_LIST 1
#define TAG_LIST_SELECTED 2
#define TAG_WATERFALL 3
#define TAG_WATERFALL_SELECTED 4

#define THINGS_PAGE_VIEW_SEGUE @"ThingsPageViewSegue"

@interface ThingsViewController ()

@end

@implementation ThingsViewController

@synthesize thingsDisplay;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:THINGS_PAGE_VIEW_SEGUE]) {
        thingsPageViewController = [segue destinationViewController];
    }
}

- (IBAction)thingsDisplaySelect:(id)sender
{
    [thingsDisplay setHidden:NO];
}

- (IBAction)thingsDisplayChange:(UIButton *)sender
{
    switch (sender.tag) {
        case TAG_LIST:
            [[thingsDisplay viewWithTag:TAG_LIST_SELECTED] setHidden:NO];
            [[thingsDisplay viewWithTag:TAG_WATERFALL_SELECTED] setHidden:YES];
            [thingsDisplay setHidden:YES];
            [thingsPageViewController showTableView];
            break;
        case TAG_WATERFALL:
            [[thingsDisplay viewWithTag:TAG_LIST_SELECTED] setHidden:YES];
            [[thingsDisplay viewWithTag:TAG_WATERFALL_SELECTED] setHidden:NO];
            [thingsDisplay setHidden:YES];
            [thingsPageViewController showCollectionView];
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [thingsDisplay setHidden:YES];
}

@end

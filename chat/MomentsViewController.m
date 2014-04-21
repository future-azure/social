//
//  MomentsViewController.m
//  chat
//
//  Created by Kenny on 2014/04/14.
//
//

#import "MomentsViewController.h"

#define MOMENTS_CELL @"MomentsCell"
#define MOMENTS_SECTION_HEADER @"MomentsSectionHeader"
#define MOMENTS_SECTION_HEADER_HEIGHT 60

#define USER @"user"
#define NAME @"name"

@interface MomentsViewController ()

@end

@implementation MomentsViewController

@synthesize momentsType;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 >>> UITableViewDataSource >>>
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataManager sharedDataManager] loadMoments].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOMENTS_CELL forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MOMENTS_CELL];
    }
    NSDictionary *moment = [[[DataManager sharedDataManager] loadMoments] objectAtIndex:indexPath.row];
    UILabel *user = (UILabel *) [cell viewWithTag:2];
    [user setText:[[moment objectForKey:USER] objectForKey:NAME]];
    return cell;
}
/*
 <<< UITableViewDataSource <<<
*/

/*
 >>> UITableViewDelegate >>>
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return MOMENTS_SECTION_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOMENTS_SECTION_HEADER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MOMENTS_SECTION_HEADER];
    }
    return cell;
}
/*
 <<< UITableViewDelegate <<<
*/

- (IBAction)momentsTypeSelect:(id)sender
{
    [momentsType setHidden:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"============");
    [momentsType setHidden:YES];
}

@end

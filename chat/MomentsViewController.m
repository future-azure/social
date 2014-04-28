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

#define TAG_AVATAR 1
#define TAG_USER 2
#define TAG_CONTEXT 3
#define TAG_DELETE 4
#define TAG_DATE 5
#define TAG_LIKE 6
#define TAG_COMMENT 7

@interface MomentsViewController ()

@end

@implementation MomentsViewController

@synthesize momentsType;
@synthesize momentsSort;

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
    NSDictionary *moment = [[[DataManager sharedDataManager] loadMoments] objectAtIndex:indexPath.row];
    [(UILabel *) [cell viewWithTag:TAG_USER] setText:[[moment objectForKey:USER] objectForKey:NAME]];
    [(UILabel *) [cell viewWithTag:TAG_CONTEXT] setText:[moment objectForKey:CONTEXT]];
    [(UILabel *) [cell viewWithTag:TAG_DATE] setText:[moment objectForKey:CREATE_TIME]];
    [(UILabel *) [cell viewWithTag:TAG_LIKE] setText:[[moment objectForKey:LIKE_CNT] stringValue]];
    [(UILabel *) [cell viewWithTag:TAG_COMMENT] setText:[[moment objectForKey:COMMENT_CNT] stringValue]];
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
    return cell;
}
/*
 <<< UITableViewDelegate <<<
*/

- (IBAction)momentsTypeSelect:(id)sender
{
    [momentsType setHidden:NO];
}

- (IBAction)momentsSortSelect:(id)sender
{
    [momentsSort setHidden:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [momentsType setHidden:YES];
    [momentsSort setHidden:YES];
}

@end

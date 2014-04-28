//
//  ThingsTableViewController.m
//  chat
//
//  Created by Kenny on 2014/04/17.
//
//

#import "ThingsTableViewController.h"

#define THING_CELL_LIST @"ThingsCellList"

#define TAG_IMG 1
#define TAG_NAME 2
#define TAG_LIKE 3
#define TAG_TAG 4
#define TAG_COMMENT 5

@interface ThingsTableViewController ()

@end

@implementation ThingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 >>> UITableViewDataSource >>>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[DataManager sharedDataManager] loadThings].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THING_CELL_LIST forIndexPath:indexPath];
    NSDictionary *thing = [[[DataManager sharedDataManager] loadThings] objectAtIndex:indexPath.row];
    [(UILabel *) [cell viewWithTag:TAG_NAME] setText:[thing objectForKey:PRODUCT_NAME]];
    [(UILabel *) [cell viewWithTag:TAG_LIKE] setText:[[thing objectForKey:LIKE_NUM] stringValue]];
    [(UILabel *) [cell viewWithTag:TAG_TAG] setText:[[thing objectForKey:TAG_CNT] stringValue]];
    [(UILabel *) [cell viewWithTag:TAG_COMMENT] setText:[[thing objectForKey:COMMENT_CNT] stringValue]];
    return cell;
}
/*
 <<< UITableViewDataSource <<<
 */

@end

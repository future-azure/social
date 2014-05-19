//
//  ThingsCollectionViewController.m
//  chat
//
//  Created by Kenny on 2014/04/17.
//
//

#import "ThingsCollectionViewController.h"

#define THINGS_CELL_WATERFALL @"ThingsCellWaterfall"

#define TAG_IMG 1
#define TAG_NAME 2
#define TAG_LIKE 3
#define TAG_TAG 4
#define TAG_COMMENT 5

@interface ThingsCollectionViewController ()

@end

@implementation ThingsCollectionViewController

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
 >>> UICollectionViewDataSource >>>
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[DataManager sharedDataManager] loadThings].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THINGS_CELL_WATERFALL
                                                                           forIndexPath:indexPath];
    NSMutableDictionary *thing = [[[DataManager sharedDataManager] loadThings] objectAtIndex:indexPath.row];
//    [(UILabel *) [cell viewWithTag:TAG_NAME] setText:[thing objectForKey:PRODUCT_NAME]];
    [(UILabel *) [cell viewWithTag:TAG_LIKE] setText:[[thing objectForKey:LIKE_NUM] stringValue]];
    [(UILabel *) [cell viewWithTag:TAG_TAG] setText:[[thing objectForKey:TAG_CNT] stringValue]];
    [(UILabel *) [cell viewWithTag:TAG_COMMENT] setText:[[thing objectForKey:COMMENT_CNT] stringValue]];
    return cell;
}
/*
 <<< UICollectionViewDataSource <<<
 */

@end

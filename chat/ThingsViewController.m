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

@interface ThingsViewController ()

@end

@implementation ThingsViewController

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
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:THINGS_CELL_WATERFALL
                                                                           forIndexPath:indexPath];
    return cell;
}
/*
 <<< UICollectionViewDataSource <<<
 */


@end

//
//  ThingsPageViewController.h
//  chat
//
//  Created by Kenny on 2014/04/18.
//
//

#import <UIKit/UIKit.h>

@interface ThingsPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    UITableViewController *thingsTableViewController;
    UICollectionViewController *thingsCollectionViewController;
}

@property (nonatomic, strong) UITableViewController *thingsTableViewController;
@property (nonatomic, strong) UICollectionViewController *thingsCollectionViewController;

- (void)showTableView;
- (void)showCollectionView;

@end

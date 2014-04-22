//
//  ThingsViewController.h
//  chat
//
//  Created by Kenny on 2014/04/12.
//
//

#import <UIKit/UIKit.h>
#import "ThingsPageViewController.h"

@interface ThingsViewController : UIViewController
{
    ThingsPageViewController *thingsPageViewController;
}

@property (weak, nonatomic) IBOutlet UIView *thingsDisplay;

- (IBAction)thingsDisplaySelect:(id)sender;
- (IBAction)thingsDisplayChange:(UIButton *)sender;

@end

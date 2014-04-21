//
//  MomentsViewController.h
//  chat
//
//  Created by Kenny on 2014/04/14.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface MomentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *momentsType;
@property (weak, nonatomic) IBOutlet UIView *momentsSort;
- (IBAction)momentsTypeSelect:(id)sender;
- (IBAction)momentsSortSelect:(id)sender;

@end

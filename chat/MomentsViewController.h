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
- (IBAction)momentsTypeSelect:(id)sender;

@end

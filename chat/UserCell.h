//
//  UserCell.h
//  chat
//
//  Created by brightvision on 14-5-28.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserCell : UITableViewCell {
    AppDelegate* myDelegate;
    
}
@property (nonatomic, strong) IBOutlet UIButton *name;
@property (nonatomic, strong) IBOutlet UILabel *status;
@property (nonatomic, strong) IBOutlet UIImageView *userImage;
@property (nonatomic, strong) IBOutlet NSDictionary *userInfo;
@property (nonatomic, strong) IBOutlet UIView *popWindow;

-(void) addClickEvent;
@end

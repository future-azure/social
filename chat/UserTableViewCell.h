//
//  UserTableViewCell.h
//  chat
//
//  Created by brightvision on 14-5-23.
//
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameText;
@property (nonatomic, strong) IBOutlet UILabel *idLabel;
@property (nonatomic, strong) IBOutlet UILabel *idText;
@property (nonatomic, strong) IBOutlet UIImageView *userImage;

@end

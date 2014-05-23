//
//  UserTableViewCell.m
//  chat
//
//  Created by brightvision on 14-5-23.
//
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell
@synthesize nameLabel;
@synthesize nameText;
@synthesize idLabel;
@synthesize idText;
@synthesize userImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

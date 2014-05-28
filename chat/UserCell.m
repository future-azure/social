//
//  UserCell.m
//  chat
//
//  Created by brightvision on 14-5-28.
//
//

#import "UserCell.h"

@implementation UserCell
@synthesize name;
@synthesize status;
@synthesize userImage;
@synthesize userInfo;
@synthesize popWindow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
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

- (void) addClickEvent{
     myDelegate = [[UIApplication sharedApplication] delegate];
    
    [name addTarget:self action:@selector(showUserDetail) forControlEvents:UIControlEventTouchUpInside];
    userImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserDetail)];
    [userImage addGestureRecognizer:singleTap];
}

-(void) showUserDetail {
    popWindow.hidden = YES;
    [myDelegate showDialog:@"test" content:userInfo[@"name"]];

}


@end

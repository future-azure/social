//
//  ContactsViewController.m
//  chat
//
//  Created by brightvision on 14-5-28.
//
//

#import "ContactsViewController.h"

@interface ContactsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *title;
@property (weak, nonatomic) IBOutlet UIButton *add;
@property (weak, nonatomic) IBOutlet UIView *popWindow;
@property (weak, nonatomic) IBOutlet UITableView *userTable;

@property (weak, nonatomic) IBOutlet UIButton *all;
@property (weak, nonatomic) IBOutlet UIImageView *allXuan;
@property (weak, nonatomic) IBOutlet UIButton *friend;
@property (weak, nonatomic) IBOutlet UIImageView *friendXuan;
@property (weak, nonatomic) IBOutlet UIButton *follow;
@property (weak, nonatomic) IBOutlet UIImageView *followXuan;
@property (weak, nonatomic) IBOutlet UIButton *followed;
@property (weak, nonatomic) IBOutlet UIImageView *followedXuan;
@property (weak, nonatomic) IBOutlet UIButton *anewFriend;
@property (weak, nonatomic) IBOutlet UIButton *anewFriendNum;
@property (weak, nonatomic) IBOutlet UIButton *recommendFriend;
@property (weak, nonatomic) IBOutlet UIButton *recommendFriendNum;

@end

@implementation ContactsViewController
@synthesize title;
@synthesize add;
@synthesize popWindow;
@synthesize all;
@synthesize allXuan;
@synthesize friend;
@synthesize follow;
@synthesize followed;
@synthesize followedXuan;
@synthesize followXuan;
@synthesize friendXuan;
@synthesize anewFriend;
@synthesize anewFriendNum;
@synthesize recommendFriend;
@synthesize recommendFriendNum;
@synthesize userTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    myDelegate = [[UIApplication sharedApplication] delegate];

    [title setTitle:[myDelegate.bundle localizedStringForKey:@"contacts_filter_close" value:nil table:@"language"] forState:UIControlStateNormal];
    [anewFriend setTitle:[myDelegate.bundle localizedStringForKey:@"new_friend" value:nil table:@"language"] forState:UIControlStateNormal];
    [recommendFriend setTitle:[myDelegate.bundle localizedStringForKey:@"recommend_friend" value:nil table:@"language"] forState:UIControlStateNormal];
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    socket.delegate = self;
    
    user = myDelegate.user;
    
    popWindow.hidden = YES;
    serverAddress = TOMCAT_SERVER;
    returnString = @"";
    
    friendMap = myDelegate.friendMap;
    friendList = [[friendMap allValues] mutableCopy];
    anewFriendNum.enabled = false;
    recommendFriendNum.enabled = false;
    if (myDelegate.newFriendCount > 0) {
         [anewFriendNum setTitle:[NSString stringWithFormat:@"%d", myDelegate.newFriendCount ] forState:UIControlStateNormal];
        anewFriendNum.enabled = false;
        
    } else {
        anewFriendNum.hidden = YES;
    }
    if (myDelegate.recommendFriendCount > 0) {
        [recommendFriendNum setTitle:[NSString stringWithFormat:@"%d", myDelegate.recommendFriendCount ] forState:UIControlStateNormal];
        recommendFriendNum.enabled = false;
        
    } else {
        recommendFriendNum.hidden = YES;
    }

    
}

/*
 >>> UITableViewDataSource >>>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return friendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserCell *cell = (UserCell *)[tableView
                                                    dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
      NSMutableDictionary *f = [friendList objectAtIndex:indexPath.row];
    cell.userInfo = f;
    [cell addClickEvent];

  //  UIImage *image = nil;
    
    // UIImageView * imageView = (UIImageView *)
    //  [cell viewWithTag:TAG_IMG];
    NSString *url = f[@"img"];
       
    //if (range.location ==NSNotFound)//不包含
    
    if (url != nil && [url rangeOfString:@"http"].length <=0)//不包含
    {
        url = [url stringByAppendingString:serverAddress];
        url = [url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        
        
    }
    [cell.userImage setImageWithURL:[NSURL URLWithString:url]
                   placeholderImage:[UIImage imageNamed:@"no_image.png"] imageId:[f[@"imgId"] intValue]];
    
    [cell.userImage.layer setCornerRadius:CGRectGetHeight([cell.userImage bounds]) / 2];
    //  profile.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    cell.userImage.layer.masksToBounds = YES;
    cell.userImage.layer.borderWidth = 2;
    cell.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    //点击事件
//    cell.userImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitImageAction:event:)];
//    [cell.userImage addGestureRecognizer:singleTap];

    
    [cell.name setTitle:f[@"name"] forState:UIControlStateNormal];
  //  [cell.name addTarget:self action:@selector(submitBtnAction:event:) forControlEvents:UIControlEventTouchUpInside];
   
    cell.status.text =f[@"status"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     popWindow.hidden = YES;
    NSDictionary *select = [friendList objectAtIndex:[indexPath row]];  //这个表示选中的那个cell上的数据
   // selectUser = [select copy];
    if ([select[@"friendType"] intValue] == 1) {
        NSArray  *keys= [NSArray arrayWithObjects:@"id", @"imgId", @"img", @"name", nil];
        NSArray *objects= [NSArray arrayWithObjects:select[@"id"], select[@"imgId"], select[@"img"],select[@"name"], nil];
        
        NSDictionary *u = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        //开始对话页面
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    popWindow.hidden = YES;
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [myDelegate.bundle localizedStringForKey:@"delete" value:nil table:@"language"];
}



/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
         NSDictionary *select = [friendList objectAtIndex:[indexPath row]];
        NSString *message = [NSString stringWithFormat:@"%@%@", [myDelegate.bundle localizedStringForKey:@"delete_friend_question" value:nil table:@"language"], select[@"name"]];
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:[myDelegate.bundle localizedStringForKey:@"del_confirm" value:nil table:@"language"] andMessage:message];
        [alertView addButtonWithTitle:[myDelegate.bundle localizedStringForKey:@"cancel" value:nil table:@"language"]
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alertView) {
                                  //   NSLog(@"Cancel Clicked");
                              }];
        [alertView addButtonWithTitle:[myDelegate.bundle localizedStringForKey:@"ok" value:nil table:@"language"]
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  //     NSLog(@"OK Clicked");
                                  selectPosition = indexPath;
                                  [self deleteFriend];
                              }];
        alertView.titleColor = [UIColor blueColor];
        alertView.cornerRadius = 10;
        alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        
        alertView.willShowHandler = ^(SIAlertView *alertView) {
            //      NSLog(@"%@, willShowHandler2", alertView);
        };
        alertView.didShowHandler = ^(SIAlertView *alertView) {
            //       NSLog(@"%@, didShowHandler2", alertView);
        };
        alertView.willDismissHandler = ^(SIAlertView *alertView) {
            //       NSLog(@"%@, willDismissHandler2", alertView);
        };
        alertView.didDismissHandler = ^(SIAlertView *alertView) {
            //        NSLog(@"%@, didDismissHandler2", alertView);
        };
        
        [alertView show];

     }
}
/*
 <<< UITableViewDataSource <<<
 */

- (void) deleteFriend
{
    type = @"DELETEFRIEND";
    [self showHubLoading:[myDelegate.bundle localizedStringForKey:@"handleing" value:nil table:@"language"]];
    
    NSString *temp = @"{\"type\":\"DELETEFRIEND\",\"object\":\"";
    
    NSMutableDictionary *f = [friendList objectAtIndex:[selectPosition row]];
    NSArray *userList = [[NSArray alloc] initWithObjects:user, f,nil];
    
 
    
    NSString *mapString = [myDelegate toJSONData:userList];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\"" withString:@"\\\""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\r" withString:@""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\n" withString:@""];
    
    NSString *temp2 = @"\",\"toUser\":0,\"fromUser\":0}\r\n";

    NSString *json = [temp stringByAppendingFormat:@"%@%@",mapString, temp2];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)titleClick:(id)sender {
    [title setTitle:[myDelegate.bundle localizedStringForKey:@"contacts_filter_open" value:nil table:@"language"] forState:UIControlStateNormal];
    popWindow.hidden = NO;

}

- (IBAction)add:(id)sender {
     popWindow.hidden = YES;
}
- (IBAction)all:(id)sender {
     popWindow.hidden = YES;
     allXuan.hidden = NO;
    friendXuan.hidden = YES;
    followedXuan.hidden = YES;
    followXuan.hidden = YES;
    [friendList removeAllObjects];
    friendList = [[friendMap allValues] mutableCopy];
    [userTable reloadData];
    
}

- (IBAction)friend:(id)sender {
     popWindow.hidden = YES;
    allXuan.hidden = YES;
    friendXuan.hidden = NO;
    followedXuan.hidden = YES;
    followXuan.hidden = YES;
    [friendList removeAllObjects];
    for (NSDictionary *f in [friendMap allValues]) {
        if ([f[@"friendType"] intValue] == 1) {
            [friendList addObject:f];
        }
    }
    [userTable reloadData];


}
- (IBAction)follow:(id)sender {
     popWindow.hidden = YES;
    allXuan.hidden = YES;
    friendXuan.hidden = YES;
    followedXuan.hidden = YES;
    followXuan.hidden = NO;
    [friendList removeAllObjects];
    for (NSDictionary *f in [friendMap allValues]) {
        if ([f[@"friendType"] intValue] == 2) {
            [friendList addObject:f];
        }
    }
    [userTable reloadData];


}
- (IBAction)followed:(id)sender {
     popWindow.hidden = YES;
    allXuan.hidden = YES;
    friendXuan.hidden = YES;
    followedXuan.hidden = NO;
    followXuan.hidden = YES;
    [friendList removeAllObjects];
    for (NSDictionary *f in [friendMap allValues]) {
        if ([f[@"friendType"] intValue] == 3) {
            [friendList addObject:f];
        }
    }
    [userTable reloadData];


}
- (IBAction)viewNewFriend:(id)sender {
     popWindow.hidden = YES;
}
- (IBAction)viewRecommendFriend:(id)sender {
     popWindow.hidden = YES;
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    
    if([@"DELETEFRIEND" isEqualToString:type]) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        returnString =[returnString stringByAppendingString:str];
        BOOL isSuffix = [str hasSuffix:@"}\r\n"];
        //  NSLog(@"%hhd", isSuffix);
        if (isSuffix) {
            
            NSData *data1 = [returnString dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&error];
            //    NSLog(@"%ld %@ %@", tag, dic, error);
            returnString = @"";
            
            NSString *str = [dic objectForKey:@"object"];
            //   NSLog(@"%@", str);
            NSData *data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%@", str);
            NSDictionary *deleteF = [NSJSONSerialization JSONObjectWithData:data2
                                                                      options:NSJSONReadingAllowFragments
                                                                 error:nil];
            if (deleteF != nil) {
                [friendList removeObjectAtIndex:[selectPosition row]];  //删除数组里的数据
                [userTable deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:selectPosition] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell

            } else {
                [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"error" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"del_friend_failure" value:nil table:@"language"]];
            }
            [self closeHubLoading];
            
        }
        
        
    }
    
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}



-(void) showHubLoading:(NSString *)str {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = str;
    
    [HUD show:YES];
    
    
}

-(void) closeHubLoading {
    [HUD removeFromSuperview];
    HUD = nil;
    
    
}
@end

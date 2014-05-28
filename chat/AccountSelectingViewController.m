//
//  AccountSelectingViewController.m
//  chat
//
//  Created by brightvision on 14-5-22.
//
//

#import "AccountSelectingViewController.h"

#define ACCOUNT_CELL @"AccountCell"
#define TAG_IMG 0
#define TAG_ID_LABLE 1
#define TAG_ID_TEXT 2
#define TAG_NAME_LABLE 3
#define TAG_NAME_TEXT 4

@interface AccountSelectingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation AccountSelectingViewController
@synthesize title;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    myDelegate = [[UIApplication sharedApplication] delegate];
    db = myDelegate.loginUserDB;
    imgdb = myDelegate.imageDB;
    loggedAccount =[db getUser];
       title.text =[myDelegate.bundle localizedStringForKey:@"account" value:nil table:@"language"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 >>> UITableViewDataSource >>>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return loggedAccount.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ACCOUNT_CELL forIndexPath:indexPath];
    
    UserTableViewCell *cell = (UserTableViewCell *)[tableView
                                      dequeueReusableCellWithIdentifier:ACCOUNT_CELL forIndexPath:indexPath];
    NSMutableDictionary *logedUser = [loggedAccount objectAtIndex:indexPath.row];
    UIImage *image = nil;
    
   // UIImageView * imageView = (UIImageView *)
  //  [cell viewWithTag:TAG_IMG];
    if ([logedUser objectForKey:@"imgId"] != nil) {
        image = [imgdb getImage:[[logedUser objectForKey:@"imgId"] intValue]];
    }
    if (image == nil) {
        [cell.userImage setImage:[UIImage imageNamed:@"icon"]];
      //  [(UIImageView *) [cell viewWithTag:TAG_IMG] setImage:[UIImage imageNamed:@"icon"]];
    } else {
       //  [(UIImageView *) [cell viewWithTag:TAG_IMG] setImage:image];
        [cell.userImage setImage:image];
    }
    
    
    [cell.userImage.layer setCornerRadius:CGRectGetHeight([cell.userImage bounds]) / 2];
    //  profile.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    cell.userImage.layer.masksToBounds = YES;
    cell.userImage.layer.borderWidth = 2;
    cell.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
  
  
//[[cell viewWithTag:TAG_IMG] setContentMode:UIViewContentModeScaleToFill];
   
   // [[cell viewWithTag:TAG_IMG].layer setCornerRadius:CGRectGetHeight([[cell viewWithTag:TAG_IMG] bounds]) / 2];
    //  profile.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
  //  [cell viewWithTag:TAG_IMG].layer.masksToBounds = YES;
   // [cell viewWithTag:TAG_IMG].layer.borderWidth = 2;
  //  [cell viewWithTag:TAG_IMG].layer.borderColor = [[UIColor whiteColor] CGColor];
    
  //  NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
   // [(UILabel *) [cell viewWithTag:TAG_ID_LABLE] setText:[myDelegate.bundle localizedStringForKey:@"id" value:nil table:@"language"]];
   // [(UILabel *) [cell viewWithTag:TAG_ID_TEXT] setText:[numberFormatter stringFromNumber:[logedUser objectForKey:@"id"]]];
   // [(UILabel *) [cell viewWithTag:TAG_NAME_LABLE] setText:[myDelegate.bundle localizedStringForKey:@"name" value:nil table:@"language"]]; [(UILabel *) [cell viewWithTag:TAG_NAME_TEXT] setText:[logedUser objectForKey:@"name"] ];
    cell.idLabel.text =[myDelegate.bundle localizedStringForKey:@"id" value:nil table:@"language"];
    cell.idText.text =[[logedUser objectForKey:@"id"] stringValue];
    cell.nameLabel.text =[myDelegate.bundle localizedStringForKey:@"name" value:nil table:@"language"];
    cell.nameText.text =[logedUser objectForKey:@"name"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *select = [loggedAccount objectAtIndex:[indexPath row]];  //这个表示选中的那个cell上的数据
    [delegate passUser:select];
    [self dismissViewControllerAnimated:YES completion:nil];
//    UIAlertView *alert = [[ UIAlertView alloc]initWithTitle:@"提示" message:titileString delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
//    [alert show];
    
}
/*
 <<< UITableViewDataSource <<<
 */





- (IBAction)back:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

@end

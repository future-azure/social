//
//  GenderSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-23.
//
//

#import "GenderSettingViewController.h"

@interface GenderSettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation GenderSettingViewController
@synthesize title;
@synthesize delegate;
@synthesize lastpath;

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
    title.text = NSLocalizedString(@"gender", nil);
    
    old_gender = @"";
    userData = @"";
    
    myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    user = myDelegate.user;
    
    if ([user objectForKey:@"gender"] != nil) {
        old_gender = [user objectForKey:@"gender"];
    }
    
    genderArray =  [NSArray arrayWithObjects:NSLocalizedString(@"male", nil),NSLocalizedString(@"female", nil), nil];
    genderArrayDisplay =  [NSArray arrayWithObjects:NSLocalizedString(@"male1", nil),NSLocalizedString(@"female1", nil), nil];
    
    if ([NSLocalizedString(@"male", nil) isEqualToString:old_gender]) {
        lastpath =[NSIndexPath indexPathForRow:0 inSection:0];
    } else if ([NSLocalizedString(@"female", nil) isEqualToString:old_gender]) {

         lastpath =[NSIndexPath indexPathForRow:1 inSection:0];
    }
    
}

/*
 >>> UITableViewDataSource >>>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return genderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ACCOUNT_CELL forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView
                                                    dequeueReusableCellWithIdentifier:@"genderCell" forIndexPath:indexPath];
    NSString *gender = [genderArrayDisplay objectAtIndex:indexPath.row];
    
    NSLog(@"%ld", (long)indexPath.section);
    [(UILabel *) [cell viewWithTag:0] setText:gender];
    
    NSUInteger row = [indexPath row];
    NSUInteger oldRow = [lastpath row];
    //如何点击当前的cell 最右边就会出现一个对号 ，在点击其他的cell 对号显示当前，上一个小时
    cell.accessoryType =  (row==oldRow && lastpath != nil)? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectGender = [genderArray objectAtIndex:[indexPath row]];  //这个表示选中的那个cell上的数据
    //[user setObject:select forKey:@"gender"];
   
    int newRow = [indexPath row];
    int oldRow = (lastpath != nil) ? [lastpath row] : -1;
    if (newRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                    indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
                                    lastpath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        lastpath = indexPath;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
/*
 <<< UITableViewDataSource <<<
 */


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)confirm:(id)sender {
    if (selectGender == nil) {
        [dataManager showDialog:NSLocalizedString(@"error", nil) content:NSLocalizedString(@"gender_no_select", nil)];
        return;
    }

    [user setObject:selectGender forKey:@"gender"];
    [user setObject:@"GENDER" forKey:@"updateType"];
    [self updateUser];

}

- (void)updateUser {
    // [self showHubLoading:NSLocalizedString(@"logging_out", nil)];
    
    type = @"UPDATEUSER";
    NSString *json;
    NSString *temp = @"\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = @"{\"type\":\"UPDATEUSER\",\"object\":\"";
    NSString *mapString = [dataManager toJSONData:user];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\"" withString:@"\\\""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\r" withString:@""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\n" withString:@""];
    
    json = [json stringByAppendingFormat:@"%@%@",mapString, temp];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
    // [self closeHubLoading];
    //  [socket disconnect];
    //  [self performSegueWithIdentifier:@"re_login" sender:self];
    
    
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    
    if([@"UPDATEUSER" isEqualToString:type]) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        userData =[userData stringByAppendingString:str];
        BOOL isSuffix = [str hasSuffix:@"}\r\n"];
        //  NSLog(@"%hhd", isSuffix);
        if (isSuffix) {
            
            NSData *data1 = [userData dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&error];
            //    NSLog(@"%ld %@ %@", tag, dic, error);
            userData = @"";
            NSString *str = [dic objectForKey:@"object"];
            //   NSLog(@"%@", str);
            if ([@"true" isEqualToString:str] || [@"TRUE" isEqualToString:str]) {
                [user removeObjectForKey:@"updateType"];
                myDelegate.user = user;
                [delegate passValue:@""];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                [user setObject:old_gender forKey:@"status"];
                [user removeObjectForKey:@"updateType"];
                [dataManager showDialog:NSLocalizedString(@"error", nil) content:NSLocalizedString(@"update_failure", nil)];
            }
            
        }
        
        
    }
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}



@end

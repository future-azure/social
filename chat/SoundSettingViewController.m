//
//  SoundSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-27.
//
//

#import "SoundSettingViewController.h"

@interface SoundSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation SoundSettingViewController
@synthesize title;
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
    myDelegate = [[UIApplication sharedApplication] delegate];

    title.text = [myDelegate.bundle localizedStringForKey:@"sound" value:nil table:@"language"];
    
        if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    user = myDelegate.user;
    
    settingDB = myDelegate.settingDB;
    setting = myDelegate.setting;
    
    soundKeyList = [[NSMutableArray alloc]initWithCapacity:5];
     soundNameList = [[NSMutableArray alloc]initWithCapacity:5];
    [self getSystemSound];

    
    if (![@"" isEqualToString:setting[@"soundName"]]) {
        for (int i = 0; i < soundKeyList.count; i++) {
            if ([[soundKeyList objectAtIndex:i] isEqualToString:setting[@"soundName"]]) {
                lastpath =[NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
    }
    if ([@"" isEqualToString:setting[@"soundName"]]) {
        lastpath =[NSIndexPath indexPathForRow:0 inSection:0];
        [setting setObject:[soundKeyList objectAtIndex:0] forKey:@"soundName"];
        [settingDB saveSetting:[user[@"id"] intValue] userSetting:setting];

    }

    
    
    
}

- (void) getSystemSound {
    
        
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sound"
                                                     ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    

    
    for (NSString *key in dict) {
      
 
            [soundKeyList addObject:key];
            [soundNameList addObject:dict[key]];
            
        
    }
}

/*
 >>> UITableViewDataSource >>>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return soundNameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ACCOUNT_CELL forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView1
                             dequeueReusableCellWithIdentifier:@"soundCell" forIndexPath:indexPath];
        
        NSString *r = [soundNameList objectAtIndex:indexPath.row];
        
        [(UILabel *) [cell viewWithTag:0] setText:r];
        
    NSUInteger row = [indexPath row];
    NSUInteger oldRow = [lastpath row];
    //如何点击当前的cell 最右边就会出现一个对号 ，在点击其他的cell 对号显示当前，上一个小时
    cell.accessoryType =  (row==oldRow && lastpath != nil)? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int newRow = [indexPath row];
    int oldRow = (lastpath != nil) ? [lastpath row] : -1;
    
    if (newRow != oldRow) {
        UITableViewCell *newCell = [tableView1 cellForRowAtIndexPath:
                                    indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView1 cellForRowAtIndexPath:
                                    lastpath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        lastpath = indexPath;
    }
    
    SystemSoundID id = [[soundKeyList objectAtIndex:newRow] intValue];
    AudioServicesPlaySystemSound(id);

    
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];
    
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
    [setting setObject:[soundKeyList objectAtIndex:lastpath.row] forKey:@"soundName"];
    [settingDB saveSetting:[user[@"id"] intValue] userSetting:setting];
    [self dismissViewControllerAnimated:YES completion:nil];



}

@end

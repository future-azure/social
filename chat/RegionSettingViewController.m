//
//  RegionSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-23.
//
//

#import "RegionSettingViewController.h"

@interface RegionSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation RegionSettingViewController
@synthesize delegate;
@synthesize title;
@synthesize lastpath;
@synthesize tableView;

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

    title.text = [myDelegate.bundle localizedStringForKey:@"region" value:nil table:@"language"];
    
    
    userData = @"";
    
    mode = 1;
    
       if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    user = myDelegate.user;
    
    if ([user objectForKey:@"regionId"] != nil) {
        old_region_id = [[user objectForKey:@"regionId"] intValue];
    }
    
    regionMap = [NSMutableDictionary dictionaryWithCapacity:5];
    countryList = [NSMutableArray arrayWithCapacity:5];
    regionList = [NSMutableArray arrayWithCapacity:5];
    provinceList = [NSMutableArray arrayWithCapacity:5];
    cityList = [NSMutableArray arrayWithCapacity:5];
    
    // self.tableView.delegate=self;
    //  self.tableView.dataSource=self;
    
    [self getRegionList];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    if (mode == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (mode == 2) {
        mode = 1;
        NSDictionary *r1 = [provinceList objectAtIndex:lastpath.row];
       // lastpath = [NSIndexPath indexPathForRow:0 inSection:0];
        for (int i = 0; i < countryList.count; i++) {
            NSDictionary *c = [countryList objectAtIndex:i];
            if ([[c objectForKey:@"id"] isEqualToNumber:[r1 objectForKey:@"country_id"]]) {
                lastpath = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastpath.row inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionMiddle];
    } else if (mode == 3){
            mode = 2;
            NSDictionary *r1 = [cityList objectAtIndex:lastpath.row];
           // lastpath = [NSIndexPath indexPathForRow:0 inSection:0];
            int idx = 0;
            for (NSDictionary *r in [regionMap objectForKey:[r1 objectForKey:@"country_id"]]) {
                bool isExist = false;
                for (NSDictionary *p in provinceList) {
                    if ([[p objectForKey:@"province"] isEqualToString:[r objectForKey:@"province"]]) {
                        isExist = true;
                        break;
                    } else {
                        isExist = false;
                    }
                }
                if (!isExist) {
                    [provinceList addObject:r];
                    if ([[r objectForKey:@"province"] isEqualToString:[r1 objectForKey:@"province"]]) {
                        lastpath = [NSIndexPath indexPathForRow:idx inSection:0];
                    }
                    idx++;
                }
            }
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastpath.row inSection:0]
                                            animated:YES
                                      scrollPosition:UITableViewScrollPositionMiddle];
            

        }
    
}

- (void)updateRegion:(NSNumber*)regionId {
    // [self showHubLoading:[myDelegate.bundle localizedStringForKey:@"logging_out" value:nil table:@"language"]];
    
    type = @"UPDATEUSER";
    NSString *json;
    NSString *temp = @"\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = @"{\"type\":\"UPDATEUSER\",\"object\":\"";
    [user setObject:regionId forKey:@"regionId"];
    [user setObject:@"CHANGEREGION" forKey:@"updateType"];
    NSString *mapString = [myDelegate toJSONData:user];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\"" withString:@"\\\""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\r" withString:@""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\n" withString:@""];
    
    json = [json stringByAppendingFormat:@"%@%@",mapString, temp];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}

/*
 >>> UITableViewDataSource >>>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (mode == 1) {
        return countryList.count;
    } else if (mode == 2) {
        return provinceList.count;
    } else {
        return cityList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ACCOUNT_CELL forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView1
                             dequeueReusableCellWithIdentifier:@"regionCell" forIndexPath:indexPath];
    
    
    if (mode == 1) {
        
        NSString *r = [[countryList objectAtIndex:indexPath.row] objectForKey:@"country_name"];
        
        [(UILabel *) [cell viewWithTag:0] setText:r];
        
    } else if (mode == 2) {
        NSString *r = [[provinceList objectAtIndex:indexPath.row] objectForKey:@"province"];
        
        [(UILabel *) [cell viewWithTag:0] setText:r];
    } else if (mode == 3) {
        NSString *r = [[cityList objectAtIndex:indexPath.row] objectForKey:@"city"];
        
        [(UILabel *) [cell viewWithTag:0] setText:r];
    }
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
    if (mode == 1) {
        if ([regionMap objectForKey:[[countryList objectAtIndex:newRow] objectForKey:@"id"]] != nil) {
            lastpath = [NSIndexPath indexPathForRow:0 inSection:0];
            mode = 2;
            [provinceList removeAllObjects];
            for (NSDictionary *r in [regionMap objectForKey:[[countryList objectAtIndex:newRow] objectForKey:@"id"]]) {
                bool isExist = false;
                for (NSDictionary * p in provinceList) {
                    if ([[p objectForKey:@"province"] isEqualToString:[r objectForKey:@"province"]]) {
                        isExist = true;
                    } else {
                        isExist = false;
                    }
                }
                if (!isExist) {
                    [provinceList addObject:r];
                }
            }
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastpath.row inSection:0]
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionMiddle];
        } else {
                for (NSDictionary *r in regionList) {
                    if ([[r objectForKey:@"country_id"] isEqualToNumber:[[countryList objectAtIndex:newRow] objectForKey:@"id"]]) {
                        [self updateRegion:[r objectForKey:@"region_id"]];
                        regionName = [r objectForKey:@"region_name"];
                        break;
                    }
                }
            }
    } else if (mode == 2) {
        NSDictionary *region = [provinceList objectAtIndex:newRow];
        [cityList removeAllObjects];
        if ([region objectForKey:@"city"] != nil && ![@"" isEqualToString:[[region objectForKey:@"city"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            lastpath = [NSIndexPath indexPathForRow:0 inSection:0];
            mode = 3;
            for (NSDictionary *r in [regionMap objectForKey:[region objectForKey:@"country_id"]]) {
                if ([[r objectForKey:@"province"] isEqualToString:[region objectForKey:@"province"]]) {
                    [cityList addObject:r];
                }
            }
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastpath.row inSection:0]
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionMiddle];
        } else {
                [self updateRegion:[region objectForKey:@"region_id"]];
                regionName = [region objectForKey:@"region_name"];
            }
        
    } else if (mode == 3) {
        [self updateRegion:[[cityList objectAtIndex:newRow] objectForKey:@"region_id"]];
        regionName = [[cityList objectAtIndex:newRow] objectForKey:@"region_name"];
        
    }
    
    if (newRow != oldRow) {
        UITableViewCell *newCell = [tableView1 cellForRowAtIndexPath:
                                    indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView1 cellForRowAtIndexPath:
                                    lastpath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        lastpath = indexPath;
    }
    
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];
    
}
/*
 <<< UITableViewDataSource <<<
 */

- (void)getRegionList {
    [self showHubLoading:[myDelegate.bundle localizedStringForKey:@"loading_data" value:nil table:@"language"]];
    
    type = @"REGIONLIST";
    NSString *json;
    NSString *temp = @"\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = @"{\"type\":\"REGIONLIST\",\"object\":\"";
    
    json = [json stringByAppendingFormat:@"%@%@",myDelegate.languageType, temp];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
    
}

- (void)getCountry {
    // [self showHubLoading:[myDelegate.bundle localizedStringForKey:@"loading_data" value:nil table:@"language"]];
    
    type = @"COUNTRY";
    NSString *json;
    NSString *temp = @"\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = @"{\"type\":\"COUNTRY\",\"object\":\"";
    
    json = [json stringByAppendingFormat:@"%@%@",myDelegate.languageType, temp];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    if([@"REGIONLIST" isEqualToString:type]) {
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
            NSData *data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%@", str);
            NSArray *regionTemp = [NSJSONSerialization JSONObjectWithData:data2
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&error];
            regionList = [regionTemp mutableCopy];
            for(id obj in regionList)
            {
                NSDictionary *r = obj;
                if ([regionMap objectForKey:[r objectForKey:@"country_id"]]) {
                    [[regionMap objectForKey:[r objectForKey:@"country_id"]] addObject:r];
                    
                } else {
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
                    [array addObject:r];
                    [regionMap setObject:array forKey:[r objectForKey:@"country_id"]];
                }
            }
            [self getCountry];
            
        }
        
        
    }
    
    if([@"COUNTRY" isEqualToString:type]) {
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
            NSData *data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%@", str);
            NSArray *regionTemp = [NSJSONSerialization JSONObjectWithData:data2
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&error];
            countryList = [regionTemp mutableCopy];
            if ([user objectForKey:@"region"] != nil && ![@"" isEqualToString:[user objectForKey:@"region"]]) {
                int regionId = [[user objectForKey:@"regionId"] intValue];
                for(id obj in regionList)
                {
                    NSDictionary *r = obj;
                    int rId = [[r objectForKey:@"region_id"] intValue];
                    if (regionId == rId) {
                        if ([r objectForKey:@"city"] != nil && ![@"" isEqualToString:[[r objectForKey:@"city"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
                            mode = 3;
                            for (id obj1 in [regionMap objectForKey:[r objectForKey:@"country_id"]]) {
                                NSDictionary *r1 = obj1;
                                if ([[r1 objectForKey:@"province"] isEqualToString:[r objectForKey:@"province"]]) {
                                    [cityList addObject:r1];
                                }
                            }
                            for (int i = 0; i< cityList.count; i++) {
                                NSDictionary *value = [cityList objectAtIndex:i];
                                if ([[value objectForKey:@"region_id"] intValue] == regionId) {
                                    lastpath =[NSIndexPath indexPathForRow:i inSection:0];
                                    break;
                                }
                            }
                        } else if ([r objectForKey:@"province"] != nil && ![@"" isEqualToString:[[r objectForKey:@"province"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
                            mode = 2;
                            for (NSDictionary *r1 in [regionMap objectForKey:[r objectForKey:@"country_id"]]) {
                                bool isExist = false;
                                for (NSDictionary *p in provinceList) {
                                    if ([[p objectForKey:@"province"] isEqualToString:[r1 objectForKey:@"province"]]) {
                                        isExist = true;
                                        break;
                                    } else {
                                        isExist = false;
                                    }
                                }
                                if (!isExist) {
                                    [provinceList addObject:r1];
                                }
                            }
                            for (int i = 0; i < provinceList.count; i++) {
                                NSDictionary *value = [provinceList objectAtIndex:i];
                                if ([[value objectForKey:@"region_id"] intValue] == regionId) {
                                    lastpath =[NSIndexPath indexPathForRow:i inSection:0];
                                    break;
                                }
                            }
                        } else {
                            mode = 1;
                            for (int i = 0; i < countryList.count; i++) {
                                NSDictionary *value = [countryList objectAtIndex:i];
                                if ([[value objectForKey:@"id"] isEqualToNumber: [r objectForKey:@"country_id"]]) {
                                    lastpath =[NSIndexPath indexPathForRow:i inSection:0];
                                    break;
                                }
                            }
                        }
                        break;
                    }
                    
                }
                
            }
            [self.tableView reloadData];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastpath.row inSection:0]
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionMiddle];
            [self closeHubLoading];
        }
        
        
    }
    
    
    
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
                [user setObject:regionName forKey:@"region"];
                myDelegate.user = user;
                [delegate passValue:@""];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                [user setObject:[NSNumber numberWithInt:old_region_id] forKey:@"regionId"];
                [user removeObjectForKey:@"updateType"];
                [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"error" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"update_failure" value:nil table:@"language"]];
            }
            
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

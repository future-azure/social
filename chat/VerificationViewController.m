//
//  VerificationViewController.m
//  chat
//
//  Created by brightvision on 14-5-12.
//
//

#import "VerificationViewController.h"

@interface VerificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *title_show;
@property (weak, nonatomic) IBOutlet UITextField *codeInput;


@end

@implementation VerificationViewController
@synthesize title;
@synthesize title_show;
@synthesize phone_number;
@synthesize country_code;
@synthesize verifiCode;

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
    
    imageData = [[NSMutableData alloc] init];
    
    myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    imgdb = myDelegate.imageDB;
    msgdb = myDelegate.messageDB;
    recentMsgDb = myDelegate.recentMessageDB;
    dataManager = myDelegate.dataManager;

    socket =[dataManager socket];
    socket.delegate = self;
    registerUser = @"";
    
    title.text = NSLocalizedString(@"verification", nil);
    NSLog(@"%@", @"verfication");
    NSString *reg = NSLocalizedString(@"verification_send", nil);
    NSString *blank = @"  ";
    NSString *content = [reg stringByAppendingFormat:@"%@%@%@%@",@"\r\n",country_code, blank, phone_number];
    
    title_show.text = content;
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) register
{
    [self showHubLoading:NSLocalizedString(@"signing_up", nil)];
    type = @"REGISTER";
    NSString *json;
    NSString *temp = @"{\"type\":\"REGISTER\",\"object\":\"{\\\"countryCode\\\":\\\"";
    NSString *temp1 = @"\\\",\\\"phoneNum\\\":\\\"";
    NSString *temp2 = @"\\\",\\\"password\\\":\\\"";
    NSString *temp3 = @"\\\"}\",\"toUser\":0,\"fromUser\":0}\r\n";
    NSString *password =[dataManager md5:verifiCode];

    json = [temp stringByAppendingFormat:@"%@%@%@%@%@%@",country_code, temp1, phone_number, temp2,password, temp3];
    NSLog(@"%@", json);

    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}

- (IBAction)back:(id)sender {
  
        [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)next:(id)sender {
    NSLog(@"next login");
    NSString *code = self.codeInput.text;
    
    if( nil == code || 0 == code.length ||![verifiCode isEqualToString:code] ) {
        [dataManager showDialog:@"error" content:@"verifycode_error"];
        return;
    }
    [self register];
    

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

-(void) loginRequest:(NSString *)obj {
    [self showHubLoading:NSLocalizedString(@"logging_in", nil)];
    
    type = @"LOGIN";
    NSString *json;
    NSString *temp = @"\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = @"{\"type\":\"LOGIN\",\"object\":\"";
    json = [json stringByAppendingFormat:@"%@%@",obj, temp];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}


- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    
    if([@"REGISTER" isEqualToString:type]) {
        [self closeHubLoading];

        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        registerUser =[registerUser stringByAppendingString:str];
        BOOL isSuffix = [str hasSuffix:@"}\r\n"];
      //  NSLog(@"%hhd", isSuffix);
        if (isSuffix) {
            
            NSData *data1 = [registerUser dataUsingEncoding:NSUTF8StringEncoding];
            registerUser = @"";
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
         //   NSLog(@"%ld %@ %@", tag, dic, error);
            
            NSString *str = [dic objectForKey:@"object"];
          //  NSLog(@"%@", str);
            NSData *data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%@", str);
            NSMutableDictionary *user = [NSJSONSerialization JSONObjectWithData:data2
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];

            //  NSLog(@"%@", user);int imgId = [[user objectForKey:@"imgId"] intValue];

            int userId = [[user objectForKey:@"id"] intValue];
            if (userId > -1) {
                //login
                NSLog(@"log in..");
                NSNumber *intString=[NSNumber numberWithInt:userId];
                NSArray  *keys = [NSArray arrayWithObjects:@"languageType", @"email", @"phoneNum", @"id", @"password",nil];
                NSArray  *objects = [NSArray arrayWithObjects:@"en", userId, userId, intString, [dataManager md5:country_code],nil];
                
                
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:3];
                [map setObject:dictionary forKey:@"user"];
                [map setObject:[NSNumber numberWithInt: 0] forKey:@"accountType"];
                [map setObject:[[AddressBook initAddressBook] readAdressBook] forKey:@"phoneList"];
                
                NSString *mapString = [dataManager toJSONData:map];
                mapString = [mapString stringByReplacingOccurrencesOfString :@"\"" withString:@"\\\""];
                mapString = [mapString stringByReplacingOccurrencesOfString :@"\r" withString:@""];
                mapString = [mapString stringByReplacingOccurrencesOfString :@"\n" withString:@""];
                
                [self loginRequest:mapString];

            } else {
                [dataManager showDialog:@"error" content:@"register_error"];
                return;

            }
            
        }
    }
    if([@"LOGIN" isEqualToString:type]) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        registerUser =[registerUser stringByAppendingString:str];
        BOOL isSuffix = [str hasSuffix:@"}\r\n"];
        //  NSLog(@"%hhd", isSuffix);
        if (isSuffix) {
            
            NSData *data1 = [registerUser dataUsingEncoding:NSUTF8StringEncoding];
            registerUser = @"";
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
            //    NSLog(@"%ld %@ %@", tag, dic, error);
            
            NSString *str = [dic objectForKey:@"object"];
            
            if (str != nil) {
                //   NSLog(@"%@", str);
                NSData *data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
                //NSLog(@"%@", str);
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data2
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:nil];
                NSArray *userList = [result objectForKey:@"user"];
                NSArray *addList = [result objectForKey:@"phoneList"];
                NSArray *recommendList = [result objectForKey:@"recommentList"];
                
                if (userList != nil && userList.count > 0) {
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    NSString *password = verifiCode;
                    NSDictionary *user = [userList objectAtIndex:0];
                    
                    [defaults setObject:[user objectForKey:@"id"] forKey:@"userId"];
                    [defaults setObject:password forKey:@"password"];
                    [defaults setObject:[user objectForKey:@"email"] forKey:@"email"];
                    [defaults setObject:[user objectForKey:@"name"] forKey:@"name"];
                    [defaults setObject:[user objectForKey:@"imgId"] forKey:@"img"];
                    [defaults synchronize];
                    
                    int userId = [[user objectForKey:@"id"] intValue];
                    [myDelegate.userDB addUserList:userList userId:userId];
                    [myDelegate.loginUserDB addUser:user password:password];
                    myDelegate.user = [user mutableCopy];
                    myDelegate.momentUpdateTime =  [NSDate date];
                    myDelegate.thingUpdateTime = [NSDate date];
                    myDelegate.setting = [myDelegate.settingDB getUserSetting:userId];
                    ImageDB *imagedb = myDelegate.imageDB;
                    int imgId = [[user objectForKey:@"imgId"] intValue];
                    UIImage *bm = [imagedb getImage:imgId];
                    if (bm != nil) {
                        myDelegate.userImage = bm;
                    } else {
                        NSString *tomcat_server = TOMCAT_SERVER;
                        NSString *url = [NSString stringWithFormat:@"%@%@", tomcat_server, [user objectForKey:@"img"]];
                        url = [url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                        NSURL *url1 = [NSURL URLWithString:url];
                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                        [request setURL:url1];
                        [request setHTTPMethod:@"GET"]; //设置请求方式
                        [request setTimeoutInterval:60];//设置超时时间
                        
                        [NSURLConnection connectionWithRequest:request delegate:self];//发送一个异步请求
                    }
                    NSArray *serverMessage =[user objectForKey:@"serverMessage"];
                    if (serverMessage != nil && serverMessage.count > 0) {
                        myDelegate.newChatFlag = 1;
                        for (id obj in serverMessage) {
                            int fromId = [[obj objectForKey:@"fromId"] intValue];
                            NSDictionary *user2 = [myDelegate.userDB selectInfo:fromId userId:userId];
                            int friendId = [[user2 objectForKey:@"id"] intValue];
                            
                            NSMutableDictionary *msgNumMap = myDelegate.anewFriendMap;
                            if ([msgNumMap objectForKey:[obj objectForKey:@"fromId"]] != nil) {
                                NSNumber *num = [NSNumber numberWithInt: fromId + 1];
                                [msgNumMap setObject:num forKey:@"fromId"];
                            } else {
                                NSNumber *num = [NSNumber numberWithInt: 1];
                                [msgNumMap setObject:num forKey:@"fromId"];
                            }
                            
                            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSString *date=[dateFormatter stringFromDate:[obj objectForKey:@"messageTime"]];
                            
                            NSArray  *keys= [NSArray arrayWithObjects:@"name", @"date", @"message", @"img",@"imgPath", @"msgType", nil];
                            NSArray *objects= [NSArray arrayWithObjects:[user2 objectForKey:@"name"], date, [obj objectForKey:@"message"], [user2 objectForKey:@"imgId"],[user2 objectForKey:@"img"], true, nil];
                            
                            NSDictionary *dic = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                            
                            [msgdb saveMsg:userId friend:friendId entity:dic];
                            
                            keys= [NSArray arrayWithObjects: @"id", @"imgPath",@"img",@"count", @"name", @"time", @"msg",  nil];
                            
                            objects= [NSArray arrayWithObjects:[user2 objectForKey:@"id"], [user2 objectForKey:@"img"],[user2 objectForKey:@"imgId"], [msgNumMap objectForKey:[user2 objectForKey:@"id"]], [user2 objectForKey:@"name"],date,[obj objectForKey:@"message"], nil];
                            
                            NSDictionary *entity1 = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                            [recentMsgDb saveMsg:userId friend:friendId entity:entity1];
                            
                        }
                    }
                    
                    for (id obj in userList) {
                        NSMutableDictionary *f = obj;
                        [myDelegate.friendMap setObject:f forKey:[f objectForKey:@"id"]];
                        int friendType = [[f objectForKey:@"friendType"] intValue];
                        if (friendType == 3) {
                            NSNumber *num =[NSNumber numberWithInt: 1];
                            NSMutableDictionary *destDict = [f mutableCopy];
                            [destDict setObject:num forKey:@"friendRequest"];
                            [myDelegate.anewFriendMap setObject:destDict forKey:[destDict objectForKey:@"id"]];
                            
                        }
                        
                        
                    }
                    [myDelegate.user setObject:@"en" forKey:@"languageType"];
                    
                    if (addList != nil && addList.count > 0) {
                        for (id obj in addList) {
                            NSDictionary *newf =obj;
                            if ([myDelegate.anewFriendMap objectForKey:[newf objectForKey:@"id"]] != nil) {
                                continue;
                            }
                            [myDelegate.anewFriendMap setObject:newf forKey:[newf objectForKey:@"id"]];
                        }
                        
                    }
                    NewFriendDB *nfdb = myDelegate.anewFriendDB;
                    NSDictionary *existNewFriend = [nfdb getUser:myDelegate.user userId:userId];
                    int count = 0;
                    NSMutableArray *deleteNewFriend = [[NSMutableArray alloc]initWithCapacity:5];
                    for (NSString *key in myDelegate.anewFriendMap) {
                        if ([existNewFriend objectForKey:key] != nil) {
                            NSDictionary *temp = [existNewFriend objectForKey:key];
                            int delete = [[temp objectForKey:@"requestDelete"] intValue];
                            if (delete == 1) {
                                [deleteNewFriend addObject:key];
                            }
                            
                        } else {
                            count++;
                            [nfdb addUser:[myDelegate.anewFriendMap objectForKey:key] user:myDelegate.user userId:userId];
                        }
                    }
                    for (NSString *key in deleteNewFriend) {
                        [myDelegate.anewFriendMap removeObjectForKey:key];
                    }
                    myDelegate.newFriendCount = count;
                    
                    if (recommendList != nil && recommendList.count > 0) {
                        for (id obj in recommendList) {
                            NSDictionary *newf =obj;
                            if ([myDelegate.recommendFriendMap objectForKey:[newf objectForKey:@"id"]] != nil) {
                                continue;
                            }
                            [myDelegate.recommendFriendMap setObject:newf forKey:[newf objectForKey:@"id"]];
                        }
                        
                    }
                    RecommendFriendDB *rfdb = myDelegate.recommendFriendDB;
                    NSDictionary *existRecommendFriend = [rfdb getUser:myDelegate.user userId:userId];
                    int count2 = 0;
                    NSMutableArray *deletedRecommendFriend = [[NSMutableArray alloc]initWithCapacity:5];
                    for (NSString *key in myDelegate.recommendFriendMap) {
                        if ([existRecommendFriend objectForKey:key] != nil) {
                            NSDictionary *temp = [existRecommendFriend objectForKey:key];
                            int delete = [[temp objectForKey:@"requestDelete"] intValue];
                            if (delete == 1) {
                                [deletedRecommendFriend addObject:key];
                            }
                            
                        } else {
                            count2++;
                            [rfdb addUser:[myDelegate.recommendFriendMap objectForKey:key] user:myDelegate.user userId:userId];
                        }
                    }
                    for (NSString *key in deletedRecommendFriend) {
                        [myDelegate.recommendFriendMap removeObjectForKey:key];
                    }
                    myDelegate.recommendFriendCount = count2;
                    [self closeHubLoading];
                    [self performSegueWithIdentifier:@"login" sender:self];
                    
                    
                } else {
                    [dataManager showDialog:NSLocalizedString(@"login_app", nil) content:NSLocalizedString(@"id_password_error", nil)];
                    [self closeHubLoading];
                }
            } else {
                [dataManager showDialog:NSLocalizedString(@"login_app", nil) content:NSLocalizedString(@"id_password_error", nil)];
                [self closeHubLoading];
            }
        }
    }

    
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}





@end

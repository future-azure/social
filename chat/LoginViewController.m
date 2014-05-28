//
//  LoginViewController.m
//  chat
//
//  Created by Kenny on 2014/04/11.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *idInput;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;

@end

@implementation LoginViewController

@synthesize scrollView;
@synthesize textField;
@synthesize switchAccount;
@synthesize signUp;
@synthesize idLabel;
@synthesize idInput;
@synthesize userImg;


- (IBAction)signUp:(id)sender {
}

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
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSNumber *userId = [defaults objectForKey:@"userId"];//根据键值取出name
    NSString *password = [defaults objectForKey:@"password"];//根据键值取出name
    if (userId != nil && password != nil) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        idLabel.text = [numberFormatter stringFromNumber:userId];
        //  idLabel.text = userId;
        textField.text = password;
        
        NSLog(@"password: %@", password);
    }

    if (userId != nil){
    myDelegate.setting = [myDelegate.settingDB getUserSetting:[userId intValue]];
    NSString* languageType = [myDelegate.setting objectForKey:@"language"];
    
    NSString *string;
    if ([@"en" isEqualToString:languageType]) {
        string = @"en";
    } else {
        string = @"zh-Hans";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    myDelegate.bundle = [NSBundle bundleWithPath:path];
    }
    
    textField.delegate = self;
    textField.placeholder = [myDelegate.bundle localizedStringForKey:@"password" value:nil table:@"language"];
    textField.secureTextEntry = true;
    idInput.placeholder = [myDelegate.bundle localizedStringForKey:@"user_id" value:nil table:@"language"];
    [switchAccount setTitle:[myDelegate.bundle localizedStringForKey:@"switch_account" value:nil table:@"language"]  forState:UIControlStateNormal];
    [signUp setTitle:[myDelegate.bundle localizedStringForKey:@"sign_up" value:nil table:@"language"] forState:UIControlStateNormal];
    
    loginData = @"";
    idInput.hidden = true;
    accountType = [NSNumber numberWithInt: 0];
    
    imageData = [[NSMutableData alloc] init];
    
   
    if (myDelegate.dataManager == nil) {
       // [dataManager socket]
        myDelegate.dataManager = [DataManager sharedDataManager];
   }
    imgdb = myDelegate.imageDB;
    msgdb = myDelegate.messageDB;
    recentMsgDb = myDelegate.recentMessageDB;
    dataManager = myDelegate.dataManager;
    [dataManager connect];
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    
}

- (void)passValue:(NSString *)value
{
    idInput.text = value;
    idInput.hidden = false;
    idLabel.hidden = true;
    textField.text = @"";
    accountType = [NSNumber numberWithInt:3];
   // NSLog(@"the get value is %@", value);
}

- (void)passUser:(NSDictionary *)value
{
    if (value != nil) {
        idInput.hidden = true;
        idLabel.text = [[value objectForKey:@"id"] stringValue];
        idLabel.hidden = false;
        textField.text = [value objectForKey:@"password"];
        if ([value objectForKey:@"imgId"] != nil) {
            int imgId = [[value objectForKey:@"imgId"] intValue];
            if (imgId != -1) {
                UIImage *bm = [imgdb getImage:imgId];
                if (bm != nil) {
                    [userImg setImage:bm];
                }
            }
        }
    }
    accountType = [NSNumber numberWithInt:1];
   // NSLog(@"the get value is %@", value);
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
    [self showHubLoading:[myDelegate.bundle localizedStringForKey:@"logging_in" value:nil table:@"language"]];
    
    type = @"LOGIN";
    NSString *json;
    NSString *temp = @"\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = @"{\"type\":\"LOGIN\",\"object\":\"";
    json = [json stringByAppendingFormat:@"%@%@",obj, temp];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}

-(void) passwordRequest:(NSString *)obj {
    [self showHubLoading:[myDelegate.bundle localizedStringForKey:@"handleing" value:nil table:@"language"]];
    
    type = @"SENDPW";
    NSString *json;
    NSString *temp = @"\",\"toUser\":0,\"fromUser\":0}\r\n";
    json = @"{\"type\":\"SENDPW\",\"object\":\"";
    json = [json stringByAppendingFormat:@"%@%@",obj, temp];
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)login:(id)sender {
    NSLog(@"log in..");
    NSString *userId = idInput.text;
    if (idInput.hidden) {
        userId = idLabel.text;
    }
    NSNumber *intString;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSArray  *keys;
    NSArray *objects;
    
    if (userId == nil || [@"" isEqualToString:userId] ||  textField.text == nil || [@"" isEqualToString:textField.text] ) {
        [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"login_app" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"id_password_empty" value:nil table:@"language"]];
        return;
    }
    
    if ([f numberFromString:userId])
    {
        intString=[NSNumber numberWithInt:[userId intValue]];
        keys = [NSArray arrayWithObjects:@"languageType", @"email", @"phoneNum", @"id", @"password",nil];
        objects = [NSArray arrayWithObjects:@"en", userId, userId, intString, [myDelegate md5:textField.text],nil];
        
    } else {
        keys = [NSArray arrayWithObjects:@"languageType", @"email", @"phoneNum",@"password", nil];
        objects = [NSArray arrayWithObjects:@"en", userId, userId, [myDelegate md5:textField.text], nil];
        
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:3];
    [map setObject:dictionary forKey:@"user"];
    [map setObject:accountType forKey:@"accountType"];
    [map setObject:[[AddressBook initAddressBook] readAdressBook] forKey:@"phoneList"];
    
    NSString *mapString = [myDelegate toJSONData:map];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\"" withString:@"\\\""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\r" withString:@""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\n" withString:@""];
    
    [self loginRequest:mapString];
}

- (void)textFieldDidBeginEditing:(UITextField *)sender
{
    [self.scrollView setContentOffset:CGPointMake(0, sender.frame.origin.y / 3) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)sender
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)switchAccount:(id)sender {
    [textField resignFirstResponder];
    [idInput resignFirstResponder];
    actionSheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:[myDelegate.bundle localizedStringForKey:@"cancel"  value:nil table:@"language"]
                                destructiveButtonTitle:nil otherButtonTitles:[myDelegate.bundle localizedStringForKey:@"logged_account" value:nil table:@"language"], [myDelegate.bundle localizedStringForKey:@"id_email" value:nil table:@"language"], [myDelegate.bundle localizedStringForKey:@"phone" value:nil table:@"language"], nil];
    
    actionSheet.buttonResponse = IBActionSheetButtonResponseFadesOnPress;
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:0];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:0];
    [actionSheet setFont:[UIFont fontWithName:[myDelegate.bundle localizedStringForKey:@"logged_account" value:nil table:@"language"] size:22] forButtonAtIndex:0];
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:1];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:1];
    [actionSheet setFont:[UIFont fontWithName:[myDelegate.bundle localizedStringForKey:@"id_email" value:nil table:@"language"] size:22] forButtonAtIndex:1];
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:2];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:2];
    [actionSheet setFont:[UIFont fontWithName:[myDelegate.bundle localizedStringForKey:@"phone" value:nil table:@"language"] size:22] forButtonAtIndex:2];
    
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:3];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forButtonAtIndex:3];
    [actionSheet setFont:[UIFont fontWithName:[myDelegate.bundle localizedStringForKey:@"cancel" value:nil table:@"language"] size:22] forButtonAtIndex:3];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet1 buttonTitleAtIndex:buttonIndex];
    if ([[myDelegate.bundle localizedStringForKey:@"logged_account" value:nil table:@"language"] isEqualToString:buttonTitle]) {
        accountType = [NSNumber numberWithInt: 1];
         [self performSegueWithIdentifier:@"loggedAccount" sender:self];
    }else if ([[myDelegate.bundle localizedStringForKey:@"id_email" value:nil table:@"language"] isEqualToString:buttonTitle]) {
        accountType = [NSNumber numberWithInt: 2];
        idLabel.hidden = true;
        idInput.hidden = false;
    }else if([[myDelegate.bundle localizedStringForKey:@"phone" value:nil table:@"language"] isEqualToString:buttonTitle]) {

        accountType = [NSNumber numberWithInt: 3];
        
        [self performSegueWithIdentifier:@"phoneLogin" sender:self];

      //  NSLog(@"confirm2");
    }else if([[myDelegate.bundle localizedStringForKey:@"cancel" value:nil table:@"language"] isEqualToString:buttonTitle]) {

        NSLog(@"cancel");
        
    }else if ([[myDelegate.bundle localizedStringForKey:@"log_in_via_email" value:nil table:@"language"] isEqualToString:buttonTitle]) {
        [self sendPassword:1];
    }else if([[myDelegate.bundle localizedStringForKey:@"log_in_via_sms" value:nil table:@"language"] isEqualToString:buttonTitle]) {
        
        [self sendPassword:2];
    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"phoneLogin"]) //"goView2"是SEGUE连线的标识
    {
       // id theSegue = segue.destinationViewController;
        PhoneLoginViewController *phoneLogin=
        
        segue.destinationViewController;
        
        phoneLogin.delegate = self;
           }
    
    if([segue.identifier isEqualToString:@"loggedAccount"]) //"goView2"是SEGUE连线的标识
    {
        // id theSegue = segue.destinationViewController;
        AccountSelectingViewController *accountLogin=
        
        segue.destinationViewController;
        
        accountLogin.delegate = self;
    }
}

-(void)sendPassword:(int)type1 {
    NSString *userId = idInput.text;
    if (idInput.hidden) {
        userId = idLabel.text;
    }
    NSNumber *intString;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSArray  *keys;
    NSArray *objects;
    
    if (userId == nil || [@"" isEqualToString:userId] ) {
        [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"info" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"id_empty" value:nil table:@"language"]];
        return;
    }
    
    if ([f numberFromString:userId])
    {
        intString=[NSNumber numberWithInt:[userId intValue]];
        keys = [NSArray arrayWithObjects:@"languageType", @"id",nil];
        objects = [NSArray arrayWithObjects:@"en", userId ,nil];
        
    } else {
        keys = [NSArray arrayWithObjects:@"languageType", @"email", nil];
        objects = [NSArray arrayWithObjects:@"en", userId, nil];
        
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:3];
    NSNumber *sendType = [NSNumber numberWithInt:type1];
    [map setObject:dictionary forKey:@"user"];
    [map setObject:accountType forKey:@"accountType"];
    [map setObject:sendType forKey:@"sendType"];
    
    NSString *mapString = [myDelegate toJSONData:map];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\"" withString:@"\\\""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\r" withString:@""];
    mapString = [mapString stringByReplacingOccurrencesOfString :@"\n" withString:@""];
    
    [self passwordRequest:mapString];
}

- (IBAction)forgotPassword:(id)sender {
    actionSheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:[myDelegate.bundle localizedStringForKey:@"cancel" value:nil table:@"language"]destructiveButtonTitle:nil otherButtonTitles:[myDelegate.bundle localizedStringForKey:@"log_in_via_email" value:nil table:@"language"], [myDelegate.bundle localizedStringForKey:@"log_in_via_sms" value:nil table:@"language"], nil];
    
    actionSheet.buttonResponse = IBActionSheetButtonResponseFadesOnPress;
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:0];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:0];
    [actionSheet setFont:[UIFont fontWithName:[myDelegate.bundle localizedStringForKey:@"log_in_via_email" value:nil table:@"language"] size:22] forButtonAtIndex:0];
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:1];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:1];
    [actionSheet setFont:[UIFont fontWithName:[myDelegate.bundle localizedStringForKey:@"log_in_via_sms" value:nil table:@"language"] size:22] forButtonAtIndex:1];
    
    
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:2];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forButtonAtIndex:2];
    [actionSheet setFont:[UIFont fontWithName:[myDelegate.bundle localizedStringForKey:@"cancel" value:nil table:@"language"] size:22] forButtonAtIndex:2];
    
    [actionSheet showInView:self.view];

}

//数据加载过程中调用,获取数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [imageData appendData:data];
}

//数据加载完成后调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage *image = [UIImage imageWithData:imageData];
    //ImageDB *imgdb = myDelegate.imageDB;

    myDelegate.userImage = image;
    int userId = [[myDelegate.user objectForKey:@"id"] intValue];
    [imgdb addImage:userId bm:image];
   // self.showImageView.image = image;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"请求网络失败:%@",error);
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    
    if([@"LOGIN" isEqualToString:type]) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        loginData =[loginData stringByAppendingString:str];
        BOOL isSuffix = [str hasSuffix:@"}\r\n"];
        //  NSLog(@"%hhd", isSuffix);
        if (isSuffix) {
            
            NSData *data1 = [loginData dataUsingEncoding:NSUTF8StringEncoding];
            loginData = @"";
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
                    NSString *password = textField.text;
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
                    NSString* languageType = [myDelegate.setting objectForKey:@"language"];
                
                NSString *string;
                if ([@"en" isEqualToString:languageType]) {
                    string = @"en";
                } else {
                    string = @"zh-Hans";
                }
                NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
                myDelegate.bundle = [NSBundle bundleWithPath:path];

                    imgdb = myDelegate.imageDB;
                    int imgId = [[user objectForKey:@"imgId"] intValue];
                    UIImage *bm = [imgdb getImage:imgId];
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
                        for (NSDictionary *obj in serverMessage) {
                            int fromId = [[obj objectForKey:@"fromId"] intValue];
                            NSLog(@"obj : %@", obj);
                            NSDictionary *user2 = [myDelegate.userDB selectInfo:fromId userId:userId];
                            int friendId = [[user2 objectForKey:@"id"] intValue];
                            
                            NSMutableDictionary *msgNumMap = myDelegate.anewMsgNumMap;
                            if ([msgNumMap objectForKey:[obj objectForKey:@"fromId"]] != nil) {
                                NSNumber *num = [NSNumber numberWithInt: fromId + 1];
                                [msgNumMap setObject:num forKey:[obj objectForKey:@"fromId"]];
                            } else {
                                NSNumber *num = [NSNumber numberWithInt: 1];
                                [msgNumMap setObject:num forKey:[obj objectForKey:@"fromId"]];
                            }
                            
                            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            NSString *date=[obj objectForKey:@"messageTime"];
                            
                            NSArray  *keys= [NSArray arrayWithObjects:@"name", @"date", @"message", @"img",@"imgPath", @"msgType", nil];
                            NSString *message = [obj objectForKey:@"message"];
                            NSLog(@"%@", message);
                            
                            NSNumber *msgType = [NSNumber numberWithInt:1];
                            NSArray *objects= [NSArray arrayWithObjects:[user2 objectForKey:@"name"], date, [obj objectForKey:@"message"], [user2 objectForKey:@"imgId"],[user2 objectForKey:@"img"], msgType, nil];
                            
                            NSDictionary *dic = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                            
                            [msgdb saveMsg:userId friend:friendId entity:dic];
                            
                            keys= [NSArray arrayWithObjects: @"id", @"imgPath",@"img",@"count", @"name", @"time", @"msg",  nil];
                            
                            objects= [NSArray arrayWithObjects:[user2 objectForKey:@"id"], [user2 objectForKey:@"img"],[user2 objectForKey:@"imgId"], [msgNumMap objectForKey:[user2 objectForKey:@"id"]], [user2 objectForKey:@"name"],date,[obj objectForKey:@"message"], nil];
                            
                            NSDictionary *entity1 = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                            [recentMsgDb saveMsg:userId friend:friendId entity:entity1];
                            
                        }
                    }
                    
                    for (int i = 1; i < userList.count; i++) {
                        NSMutableDictionary *f = [userList objectAtIndex:i];
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
                    [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"login_app" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"id_password_error" value:nil table:@"language"]];
                    [self closeHubLoading];
                }
            } else {
                [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"login_app" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"id_password_error" value:nil table:@"language"]];
                [self closeHubLoading];
            }
        }
    }
    if([@"SENDPW" isEqualToString:type]) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        loginData =[loginData stringByAppendingString:str];
        BOOL isSuffix = [str hasSuffix:@"}\r\n"];
        //  NSLog(@"%hhd", isSuffix);
        if (isSuffix) {
            
            NSData *data1 = [loginData dataUsingEncoding:NSUTF8StringEncoding];
            loginData = @"";
            [self closeHubLoading];

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
                NSNumber *successNum = [result objectForKey:@"result"];
                NSNumber *typeNum = [result objectForKey:@"sendType"];
                int success = [successNum intValue];
                 int sendType = [typeNum intValue];
                
                if (success == 1) {
                    if (sendType == 1) {
                        [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"info" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"send_pw_email_success" value:nil table:@"language"]];
                    } else if(sendType == 2) {
                        [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"info" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"send_pw_sms_success" value:nil table:@"language"]];
                    }
                } else if (success == 2) {
                     [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"error" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"send_pw_email_error" value:nil table:@"language"]];
                } else {
                     [myDelegate showDialog:[myDelegate.bundle localizedStringForKey:@"error" value:nil table:@"language"] content:[myDelegate.bundle localizedStringForKey:@"send_pw_error" value:nil table:@"language"]];
                }
                
            }
        }
    }

    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}



@end

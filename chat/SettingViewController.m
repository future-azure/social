//
//  SettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-6.
//
//

#import "SettingViewController.h"

#define BIG_IMG_WIDTH 264
#define BIG_IMG_HEIGHT 264

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *points;
@property (weak, nonatomic) IBOutlet UIButton *vip;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIButton *account;
@property (weak, nonatomic) IBOutlet UIButton *setting;
@property (weak, nonatomic) IBOutlet UIButton *about;

@end



@implementation SettingViewController

@synthesize profile;
@synthesize title;
@synthesize userName;
@synthesize userId;
@synthesize points;
@synthesize vip;
@synthesize navigationItem;
@synthesize account;
@synthesize setting;
@synthesize about;

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
    navigationItem.hidesBackButton = true;
    title.text =NSLocalizedString(@"me", nil);
    
    [account setTitle:[@"    " stringByAppendingString: NSLocalizedString(@"account", nil)] forState:UIControlStateNormal];
    [setting setTitle:[@"    " stringByAppendingString: NSLocalizedString(@"setting", nil)] forState:UIControlStateNormal];
    [about setTitle:[@"    " stringByAppendingString: NSLocalizedString(@"about", nil)] forState:UIControlStateNormal];
   
    
    myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
   
    dataManager = myDelegate.dataManager;
     socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;

    user = myDelegate.user;
    
    userName.text = [user objectForKey:@"name"] == nil? NSLocalizedString(@"setting_name", nil) : [user objectForKey:@"name"];
    
    userId.text = [NSLocalizedString(@"id", nil) stringByAppendingFormat:@"%@%@",@": ", [[user objectForKey:@"id"] stringValue]];
    points.text = [NSLocalizedString(@"points", nil) stringByAppendingFormat:@"%@%@",@" ", [[user objectForKey:@"points"] stringValue]];
    
    int isVip = [[user objectForKey:@"vip"] intValue];
    if (isVip == 0) {
        vip.hidden = true;
    } else {
        vip.hidden = false;
    }
    
    // Do any additional setup after loading the view.

    [self.profile setImage:myDelegate.userImage];
    

    [profile.layer setCornerRadius:CGRectGetHeight([profile bounds]) / 2];
  //  profile.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    profile.layer.masksToBounds = YES;
    profile.layer.borderWidth = 2;
    profile.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    //点击事件
    profile.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage)];    [profile addGestureRecognizer:singleTap];
 //   profile.layer.cornerRadius = 50;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showBigImage {
	//创建灰色透明背景，使其背后内容不可操作
	UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 520)];
	[bgView setBackgroundColor:[UIColor colorWithRed:0.3
											   green:0.3
												blue:0.3
											   alpha:0.7]];
	[self.view addSubview:bgView];
//	[bgView release];
	
	//创建边框视图
	UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BIG_IMG_WIDTH+16, BIG_IMG_HEIGHT+16)];
	//将图层的边框设置为圆脚
    borderView.layer.cornerRadius = 8;
	borderView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
	borderView.layer.borderWidth = 8;
	borderView.layer.borderColor = [[UIColor colorWithRed:0.9
													green:0.9
													 blue:0.9
													alpha:0.7] CGColor];
	[borderView setCenter:bgView.center];
	[bgView addSubview:borderView];
	//[borderView release];
	
	//创建关闭按钮
	UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
	[closeBtn addTarget:self action:@selector(removeBigImage:) forControlEvents:UIControlEventTouchUpInside];
	NSLog(@"borderview is %@",borderView);
	[closeBtn setFrame:CGRectMake(borderView.frame.origin.x+borderView.frame.size.width-20, borderView.frame.origin.y-6, 26, 27)];
	[bgView addSubview:closeBtn];
	
	//创建显示图像视图
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, BIG_IMG_WIDTH, BIG_IMG_HEIGHT)];
	[imgView setImage:myDelegate.userImage];
    [imgView.layer setCornerRadius:CGRectGetHeight([imgView bounds]) / 2];
    //  profile.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    imgView.layer.masksToBounds = YES;
    imgView.layer.borderWidth = 2;
    imgView.layer.borderColor = [[UIColor whiteColor] CGColor];

	[borderView addSubview:imgView];
//	[imgView release];
    
}

//移除大图片
-(void)removeBigImage:(UIButton *)btn{
	[[btn superview] removeFromSuperview];
}

- (IBAction)logOut:(id)sender {
    [self showHubLoading:NSLocalizedString(@"logging_out", nil)];
        
        type = @"LOGOUT";
        NSString *json;
        NSString *temp = @"\",\"toUser\":0,\"fromUser\":0}\r\n";
        json = @"{\"type\":\"LOGOUT\",\"object\":\"";
        NSString *mapString = [dataManager toJSONData:user];
        mapString = [mapString stringByReplacingOccurrencesOfString :@"\"" withString:@"\\\""];
        mapString = [mapString stringByReplacingOccurrencesOfString :@"\r" withString:@""];
        mapString = [mapString stringByReplacingOccurrencesOfString :@"\n" withString:@""];

        json = [json stringByAppendingFormat:@"%@%@",mapString, temp];
        NSLog(@"%@", json);
        [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
        [socket readDataWithTimeout:-1 tag:0];
    [self closeHubLoading];
      [socket disconnect];
    [self performSegueWithIdentifier:@"re_login" sender:self];

    

}
- (IBAction)profileSetting:(id)sender {
  
     [self performSegueWithIdentifier:@"profile_setting" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"profile_setting"]) //"goView2"是SEGUE连线的标识
    {
        // id theSegue = segue.destinationViewController;
        ProfileSettingViewController *phoneLogin=
        
        segue.destinationViewController;
        
        phoneLogin.delegate = self;
    }
    
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


- (void)passValue:(NSString *)value
{
    user = myDelegate.user;
    
    userName.text = [user objectForKey:@"name"] == nil? NSLocalizedString(@"setting_name", nil) : [user objectForKey:@"name"];
    
    userId.text = [NSLocalizedString(@"id", nil) stringByAppendingFormat:@"%@%@",@": ", [[user objectForKey:@"id"] stringValue]];
    points.text = [NSLocalizedString(@"points", nil) stringByAppendingFormat:@"%@%@",@" ", [[user objectForKey:@"points"] stringValue]];
    
    int isVip = [[user objectForKey:@"vip"] intValue];
    if (isVip == 0) {
        vip.hidden = true;
    } else {
        vip.hidden = false;
    }
    
    // Do any additional setup after loading the view.
    
    [self.profile setImage:myDelegate.userImage];

}

- (void)passUser:(NSDictionary *)value
{
}

- (void)passImage:(UIImage *)image {
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

//断开连接
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"onSocketDidDisconnect:%p",sock);
}


@end

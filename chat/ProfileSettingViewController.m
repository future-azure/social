//
//  ProfileSettingViewController.m
//  chat
//
//  Created by brightvision on 14-5-12.
//
//

#import "ProfileSettingViewController.h"
#define BIG_IMG_WIDTH 264
#define BIG_IMG_HEIGHT 264

@interface ProfileSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UIButton *gender;
@property (weak, nonatomic) IBOutlet UIButton *region;
@property (weak, nonatomic) IBOutlet UIButton *status;
@property (weak, nonatomic) IBOutlet UILabel *curName;
@property (weak, nonatomic) IBOutlet UILabel *curGender;
@property (weak, nonatomic) IBOutlet UILabel *curRegion;
@property (weak, nonatomic) IBOutlet UILabel *curStatus;

@end

@implementation ProfileSettingViewController
@synthesize delegate;
@synthesize title;
@synthesize profileImage;
@synthesize userImage;
@synthesize name;
@synthesize gender;
@synthesize region;
@synthesize status;
@synthesize curGender;
@synthesize curName;
@synthesize curRegion;
@synthesize curStatus;

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
    title.text = NSLocalizedString(@"profile", nil);
    [profileImage setTitle:[@"    " stringByAppendingString: NSLocalizedString(@"profile_image", nil)] forState:UIControlStateNormal];
    [name setTitle:[@"    " stringByAppendingString: NSLocalizedString(@"name", nil)] forState:UIControlStateNormal];
    [gender setTitle:[@"    " stringByAppendingString: NSLocalizedString(@"gender", nil)] forState:UIControlStateNormal];
    [region setTitle:[@"    " stringByAppendingString: NSLocalizedString(@"region", nil)] forState:UIControlStateNormal];
    [status setTitle:[@"    " stringByAppendingString: NSLocalizedString(@"status", nil)] forState:UIControlStateNormal];
    
    myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.dataManager == nil) {
        myDelegate.dataManager = [DataManager sharedDataManager];
    }
    
    dataManager = myDelegate.dataManager;
    socket =[dataManager socket];
    // [[DataManager sharedDataManager] loadCountry];
    socket.delegate = self;
    
    user = myDelegate.user;

    curName.text = [user objectForKey:@"name"]==nil? NSLocalizedString(@"not_setting", nil) : [user objectForKey:@"name"];
     curRegion.text = [user objectForKey:@"region"]==nil? NSLocalizedString(@"not_setting", nil) : [user objectForKey:@"region"];
     curGender.text = [user objectForKey:@"gender"]==nil? NSLocalizedString(@"not_setting", nil) : [user objectForKey:@"gender"];
     curStatus.text = [user objectForKey:@"status"]==nil? NSLocalizedString(@"not_setting", nil) : [user objectForKey:@"status"];
    
    [userImage setImage:myDelegate.userImage];
    
    
    [userImage.layer setCornerRadius:CGRectGetHeight([userImage bounds]) / 2];
    //  profile.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    userImage.layer.masksToBounds = YES;
    userImage.layer.borderWidth = 2;
    userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    //点击事件
    userImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage)];
    [userImage addGestureRecognizer:singleTap];

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    NSString *buttonTitle = [actionSheet1 buttonTitleAtIndex:buttonIndex];
    if ([NSLocalizedString(@"camera", nil) isEqualToString:buttonTitle]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else{
            NSLog(@"模拟器无法打开相机");
            return;
        }
        [self presentModalViewController:picker animated:YES];
       
    }else if ([NSLocalizedString(@"album", nil) isEqualToString:buttonTitle]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
        
    }else if([NSLocalizedString(@"cancel", nil) isEqualToString:buttonTitle]) {
        
        NSLog(@"cancel");
    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

#pragma 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        CaptureViewController *captureView = [[CaptureViewController alloc] init];
        captureView.delegate = self;
        captureView.image = image;
        //隐藏UIImagePickerController本身的导航栏
        picker.navigationBar.hidden = YES;
        [picker pushViewController:captureView animated:YES];
        
    }
}

#pragma mark - 图片回传协议方法
-(void)passImage:(UIImage *)image
{
    userImage.image = image;
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (IBAction)profileSetting:(id)sender {
    actionSheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"camera", nil), NSLocalizedString(@"album", nil), nil];
    
    actionSheet.buttonResponse = IBActionSheetButtonResponseFadesOnPress;
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:0];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:0];
    [actionSheet setFont:[UIFont fontWithName:NSLocalizedString(@"camera", nil) size:22] forButtonAtIndex:0];
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:1];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:1];
    [actionSheet setFont:[UIFont fontWithName:NSLocalizedString(@"album", nil) size:22] forButtonAtIndex:1];
    [actionSheet setButtonTextColor:[UIColor whiteColor] forButtonAtIndex:2];
    [actionSheet setButtonBackgroundColor:[UIColor colorWithRed:253/255.0 green:108/255.0 blue:53/255.0 alpha:1] forButtonAtIndex:2];
    [actionSheet setFont:[UIFont fontWithName:NSLocalizedString(@"cancel", nil) size:22] forButtonAtIndex:2];
    [actionSheet showInView:self.view];
    
}
- (IBAction)nameSetting:(id)sender {
    [self performSegueWithIdentifier:@"name" sender:self];

}
- (IBAction)genderSetting:(id)sender {
    [self performSegueWithIdentifier:@"gender" sender:self];
}
- (IBAction)regionSetting:(id)sender {
    [self performSegueWithIdentifier:@"region" sender:self];

}
- (IBAction)statusSetting:(id)sender {
    [self performSegueWithIdentifier:@"status" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"name"]) //"goView2"是SEGUE连线的标识
    {
        // id theSegue = segue.destinationViewController;
        NameSettingViewController *phoneLogin=
        
        segue.destinationViewController;
        
        phoneLogin.delegate = self;
    }
    if([segue.identifier isEqualToString:@"region"]) //"goView2"是SEGUE连线的标识
    {
        // id theSegue = segue.destinationViewController;
        RegionSettingViewController *phoneLogin=
        
        segue.destinationViewController;
        
        phoneLogin.delegate = self;
    }
    if([segue.identifier isEqualToString:@"status"]) //"goView2"是SEGUE连线的标识
    {
        // id theSegue = segue.destinationViewController;
        StatusSettingViewController *phoneLogin=
        
        segue.destinationViewController;
        
        phoneLogin.delegate = self;
    }
    if([segue.identifier isEqualToString:@"gender"]) //"goView2"是SEGUE连线的标识
    {
        // id theSegue = segue.destinationViewController;
        GenderSettingViewController *phoneLogin=
        
        segue.destinationViewController;
        
        phoneLogin.delegate = self;
    }

    
}

- (void) passValue:(NSString *)value {
    user = myDelegate.user;
    curName.text = [user objectForKey:@"name"]==nil? NSLocalizedString(@"not_setting", nil) : [user objectForKey:@"name"];
    curRegion.text = [user objectForKey:@"region"]==nil? NSLocalizedString(@"not_setting", nil) : [user objectForKey:@"region"];
    curGender.text = [user objectForKey:@"gender"]==nil? NSLocalizedString(@"not_setting", nil) : [user objectForKey:@"gender"];
    curStatus.text = [user objectForKey:@"status"]==nil? NSLocalizedString(@"not_setting", nil) : [user objectForKey:@"status"];

}

- (void) passUser:(NSDictionary *)value {
    
}

- (IBAction)back:(id)sender {
    [delegate passValue:@""];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end

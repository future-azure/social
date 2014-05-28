//
//  SoundSettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-27.
//
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {

    NSString *soundName;
    NSString *type;
    AsyncSocket *socket;
    
    NSMutableDictionary *user;
    DataManager *dataManager;
    
    AppDelegate *myDelegate;
    
    SettingDB *settingDB;
    
    NSMutableDictionary *setting;
    NSMutableArray *soundKeyList;
     NSMutableArray *soundNameList;

    
    
}

@property (strong,nonatomic)NSIndexPath *lastpath ;

@end


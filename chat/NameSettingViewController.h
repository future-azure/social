//
//  NameSettingViewController.h
//  chat
//
//  Created by brightvision on 14-5-23.
//
//

#import <UIKit/UIKit.h>
#import "UIViewPassValueDelegate.h"

@interface NameSettingViewController : UIViewController<UIViewPassValueDelegate> {
        NSObject<UIViewPassValueDelegate> * delegate;
    
    
}
@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;

@end

//
//  HMCustomSwitch.h
//  chat
//
//  Created by brightvision on 14-5-23.
//
//

#import <UIKit/UIKit.h>

@interface HMCustomSwitch : UISlider {
    BOOL on;
    UIColor *tintColor;
    UIView *clippingView;
    UILabel *rightLabel;
    UILabel *leftLabel;
    
    // private member
    BOOL m_touchedSelf;
}

@property(nonatomic,getter=isOn) BOOL on;
@property (nonatomic,retain) UIColor *tintColor;
@property (nonatomic,retain) UIView *clippingView;
@property (nonatomic,retain) UILabel *rightLabel;
@property (nonatomic,retain) UILabel *leftLabel;

+ (HMCustomSwitch *) switchWithLeftText: (NSString *) tag1 andRight: (NSString *) tag2;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end


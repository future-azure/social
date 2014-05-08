//
//  ThingsFilterViewController.h
//  chat
//
//  Created by Kenny on 2014/04/23.
//
//

#import <UIKit/UIKit.h>

@interface ThingsFilterViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *minItems;
    NSArray *maxItems;
    NSInteger min;
    NSInteger max;
    NSInteger type;
}

@end

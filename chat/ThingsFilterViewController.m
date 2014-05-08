//
//  ThingsFilterViewController.m
//  chat
//
//  Created by Kenny on 2014/04/23.
//
//

#import "ThingsFilterViewController.h"

#define TAG_MIN 2
#define TAG_MAX 3

@interface ThingsFilterViewController ()

@end

@implementation ThingsFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    minItems = [NSArray arrayWithObjects:@"$50K", @"$100K", @"$150K", @"$200K", @"$250K", @"$250K", @"$250K", nil];
    maxItems = [NSArray arrayWithObjects:@"$50K", @"$100K", @"$150K", @"$200K", @"$250K", @"$250K", @"$250K", nil];
    min = 0;
    max = 0;
    type = 2;
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

/*
 >>> UIPickerViewDataSource >>>
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (type) {
        case TAG_MIN:
            return minItems.count;
        case TAG_MAX:
            return maxItems.count;
        default:
            return 0;
    }
}
/*
 <<< UIPickerViewDataSource <<<
 */

/*
 >>> UIPickerViewDelegate >>>
 */
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0:
//            return 70;
//        case 1:
//            return 30;
//        default:
//            return 0;
//    }
//}

//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 50;
//}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0:
//            return @"test";
//        case 1:
//            return @"min";
//        default:
//            return @"";
//    }
//}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0)
//{
//    
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *) view;
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor lightGrayColor];
    }
    switch (type) {
        case TAG_MIN:
            label.text = [minItems objectAtIndex:row];
        case TAG_MAX:
            label.text = [maxItems objectAtIndex:row];
        default:
            break;
    }
    return label;
    
//    UILabel *label = (UILabel *) view;
//    if (label == nil) {
//        NSLog(@"NIL - %ld", row);
////        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
////        label.text = [NSString stringWithFormat:@"%ld", row];
////        label.backgroundColor = [UIColor blueColor];
//    
//        label = [[UILabel alloc] init];
//        label.backgroundColor = [UIColor lightGrayColor];
//        label.textColor = [UIColor blackColor];
//        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
//        label.text = [NSString stringWithFormat:@"  %ld", row+1];
//        return label;
//    }
//    return label;
////    if (row < min - 1 || row > min + 1) {
////        return nil;
////    } else {
////        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
////        label.text = [NSString stringWithFormat:@"%ld", row];
////        label.backgroundColor = [UIColor blueColor];
////        return label;
////    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    min = row;
}
/*
 <<< UIPickerViewDelegate <<<
 */

@end

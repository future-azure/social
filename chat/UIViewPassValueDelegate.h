//
//  UIViewPassValueDelegate.h
//  chat
//
//  Created by brightvision on 14-5-22.
//
//

#import <Foundation/Foundation.h>

@protocol UIViewPassValueDelegate <NSObject>
- (void)passValue:(NSString *)value;
- (void)passUser:(NSDictionary *)value;
- (void)passImage:(UIImage *)image;


@end

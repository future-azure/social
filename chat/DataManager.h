//
//  DataManager.h
//  chat
//
//  Created by Kenny on 2014/04/14.
//
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject {
    NSMutableArray *moments;
    NSMutableArray *things;
}

@property (nonatomic, strong) NSMutableArray *moments;
@property (nonatomic, strong) NSMutableArray *things;

+ (DataManager *)sharedDataManager;
+ (UIImage *) imageWithColor:(UIColor*)color size:(CGSize)size;
+ (UIImage *)resize:(UIImage *)image rect:(CGRect)rect;

- (NSArray *)loadMoments;

@end

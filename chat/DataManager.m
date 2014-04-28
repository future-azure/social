//
//  DataManager.m
//  chat
//
//  Created by Kenny on 2014/04/14.
//
//

#import "DataManager.h"

@implementation DataManager

@synthesize moments;
@synthesize things;

+ (DataManager *)sharedDataManager
{
    static DataManager *sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataManager = [[self alloc] init];
    });
    return sharedDataManager;
}

+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)resize:(UIImage *)image rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (id)init
{
    if (self = [super init]) {
        moments = [[NSMutableArray alloc] initWithCapacity:10];
        things = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (NSArray *)loadMoments
{
    if (moments.count == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FINDALLMOMENT_result" ofType:@"txt"];
        NSString *json = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments
                                                             error:nil];
        [moments addObjectsFromArray:arr];
    }

    return moments;
}

- (NSArray *)loadThings
{
    if (things.count == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FINDTHING_result" ofType:@"txt"];
        NSString *json = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments
                                                             error:nil];
        data = [[dic objectForKey:@"object"] dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingAllowFragments
                                                         error:nil];
        [things addObjectsFromArray:arr];
    }
    return things;
}

@end

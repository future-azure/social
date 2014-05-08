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
        socket = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *error = nil;
        [socket connectToHost:@"116.228.54.226" onPort:8085 withTimeout:10 error:&error];
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

/*
 >>> AsyncSocketDelegate >>>
 */
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Connected!");
    NSString *json = @"{\"type\":\"FINDALLMOMENT\",\"object\":\"9\",\"toUser\":0,\"fromUser\":0}\r\n";
//    NSString *json = @"{\"type\":\"FINDALLTHING\",\"toUser\":0,\"fromUser\":0}";
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];

//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSString *str = [NSString stringWithUTF8String:[data bytes]];
//    NSLog(@"%@", dic);
    NSLog(@"%ld %@ %@", tag, dic, error);
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"didWriteDataWithTag %ld", tag);
    [socket readDataWithTimeout:-1 tag:0];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"Disconnected!");
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"ERROR - %@", err);
}

/*
 <<< AsyncSocketDelegate <<<
 */

@end

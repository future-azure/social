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
@synthesize country;
@synthesize type;
@synthesize socket;



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

        
        defaults = [self getDefaults];
        
        moments = [[NSMutableArray alloc] initWithCapacity:10];
        things = [[NSMutableArray alloc] initWithCapacity:10];
        socket = [[AsyncSocket alloc] initWithDelegate:self];
//        NSError *error = nil;
//        
//       //  [socket connectToHost:@"116.228.54.226" onPort:8085 withTimeout:10 error:&error];
//        [socket connectToHost:@"192.168.1.118" onPort:8080 withTimeout:10 error:&error];
        
    }
    return self;
}

-(void) connect {
    NSError *error = nil;
    
    //  [socket connectToHost:@"116.228.54.226" onPort:8085 withTimeout:10 error:&error];
    [socket connectToHost:@"192.168.1.118" onPort:8080 withTimeout:10 error:&error];
}

- (NSArray *)loadMoments
{
   // type = @"FINDALLMOMENT";
   // NSString *json;
    
  //  json = @"{\"type\":\"FINDALLMOMENT\",\"object\":\"9\",\"toUser\":0,\"fromUser\":0}\r\n";
    
 //   NSLog(@"%@", json);
   // [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    
    if (moments.count == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FINDALLMOMENT_result" ofType:@"txt"];
        NSString *json = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
        //       NSLog(@"%@ %@", dic, error);
        
        NSString *str = [dic objectForKey:@"object"];
        NSData *data1 = [str dataUsingEncoding:NSUTF8StringEncoding];
        //NSLog(@"%@", str);
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data1
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
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
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

- (void)loadCountry
{
    [country removeAllObjects];
    //  NSError *error = nil;
    type = @"COUNTRY";
    NSString *json;
    
    json = @"{\"type\":\"COUNTRY\",\"object\":\"en\",\"toUser\":0,\"fromUser\":0}\r\n";
    
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
    [socket readDataWithTimeout:-1 tag:0];
    //  [socket connectToHost:@"192.168.1.118" onPort:8080 withTimeout:10 error:&error];
}

- (NSUserDefaults *)getDefaults {
    return [NSUserDefaults standardUserDefaults];
}

/*
 >>> AsyncSocketDelegate >>>
 */
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Connected!");
    //    NSString *json;
    //    if([@"FINDALLMOMENT" isEqualToString:type]) {
    //        json = @"{\"type\":\"FINDALLMOMENT\",\"object\":\"9\",\"toUser\":0,\"fromUser\":0}\r\n";
    //    }else if([@"COUNTRY" isEqualToString:type]) {
    //         json = @"{\"type\":\"COUNTRY\",\"object\":\"en\",\"toUser\":0,\"fromUser\":0}\r\n";
    //    }
    //
    //    NSLog(@"%@", json);
    //    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSError *error = nil;
    
    if([@"FINDALLMOMENT" isEqualToString:type]) {
//        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS MOMENTINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT,num INTEGER, data TEXT)";
//        [self execSql:sqlCreateTable];
//        
//        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        BOOL isPerfix = [str hasPrefix:@"{\"type\":"];
//        if(isPerfix) {
//            NSString *sql =
//            @"DELETE FROM MOMENTINFO";
//            [self execSql:sql];
//            
//        }
//        
//        NSString *sql1 = [NSString stringWithFormat:
//                          @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
//                          MOMENTINFO, NUM, DATA,  @"1", str ];
//        
//        
//        [self execSql:sql1];
//        
//        BOOL isSuffix = [str hasSuffix:@"\"}\r\n"];
//        NSLog(@"%hhd", isSuffix);
//        if (isSuffix) {
//            
//            NSString *sqlQuery = @"SELECT * FROM MOMENTINFO WHERE NUM = 1";
//            sqlite3_stmt * statement;
//            
//            NSString *content = @"";
//            
//            if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
//                while (sqlite3_step(statement) == SQLITE_ROW) {
//                    char *name = (char*)sqlite3_column_text(statement, 2);
//                    NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
//                    content = [content stringByAppendingString: nsNameStr];
//                }
//            }
//            sqlite3_close(db);
//            NSData *data1 = [content dataUsingEncoding:NSUTF8StringEncoding];
//            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
//                                                                options:NSJSONReadingAllowFragments
//                                                                  error:&error];
//            
//            NSLog(@"%ld %@ %@", tag, dic, error);
//        }
    }
    
    if([@"COUNTRY" isEqualToString:type]) {
//        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS COUNTRYINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT,num INTEGER, data TEXT)";
//        [self execSql:sqlCreateTable];
//        
//        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        BOOL isPerfix = [str hasPrefix:@"{\"type\":"];
//        if(isPerfix) {
//            NSString *sql =
//            @"DELETE FROM COUNTRYINFO";
//            [self execSql:sql];
//            
//        }
//        
//        NSString *sql1 = [NSString stringWithFormat:
//                          @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
//                          COUNTRYINFO, NUM, DATA,  @"1", str ];
//        
//        
//        [self execSql:sql1];
//        
//        BOOL isSuffix = [str hasSuffix:@"\"}\r\n"];
//        NSLog(@"%hhd", isSuffix);
//        if (isSuffix) {
//            
//            NSString *sqlQuery = @"SELECT * FROM COUNTRYINFO WHERE NUM = 1";
//            sqlite3_stmt * statement;
//            
//            NSString *content = @"";
//            
//            if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
//                while (sqlite3_step(statement) == SQLITE_ROW) {
//                    char *name = (char*)sqlite3_column_text(statement, 2);
//                    NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
//                    content = [content stringByAppendingString: nsNameStr];
//                }
//            }
//            sqlite3_close(db);
//            NSData *data1 = [content dataUsingEncoding:NSUTF8StringEncoding];
//        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
//                                                            options:NSJSONReadingAllowFragments
//                                                              error:&error];
//        NSLog(@"%ld %@ %@", tag, dic, error);
//
//        NSString *str = [dic objectForKey:@"object"];
//        NSLog(@"%@", str);
//        NSData *data2 = [str dataUsingEncoding:NSUTF8StringEncoding];
//        //NSLog(@"%@", str);
//        country = [NSJSONSerialization JSONObjectWithData:data2
//                                                       options:NSJSONReadingAllowFragments
//                                                         error:nil];
//            NSLog(@"%@", country);

//           }
        
        
    }
    
    
    [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"didWriteDataWithTag %ld", tag);
  //  [socket readDataWithTimeout:-1 tag:0];
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




- (void) showDialog:(NSString *)dialogType content:(NSString*)content {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(dialogType, nil) andMessage:NSLocalizedString(content, nil)];
    [alertView addButtonWithTitle:NSLocalizedString(@"ok", nil)                                 type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                          //    NSLog(@"OK Clicked");
                              
                          }];
    alertView.titleColor = [UIColor blueColor];
    alertView.cornerRadius = 10;
    alertView.buttonFont = [UIFont boldSystemFontOfSize:15];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
   //     NSLog(@"%@, willShowHandler2", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
 //       NSLog(@"%@, didShowHandler2", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
  //      NSLog(@"%@, willDismissHandler2", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
   //     NSLog(@"%@, didDismissHandler2", alertView);
    };
    
    [alertView show];

}




- (NSString *)md5:(NSString *)str

{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ]; 
    
}

- (NSString *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData
                                     encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}






@end

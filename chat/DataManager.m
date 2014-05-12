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
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
        
        if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
        }

        moments = [[NSMutableArray alloc] initWithCapacity:10];
        things = [[NSMutableArray alloc] initWithCapacity:10];
        socket = [[AsyncSocket alloc] initWithDelegate:self];
       
      //  [socket connectToHost:@"116.228.54.226" onPort:8085 withTimeout:10 error:&error];
        
        }
    return self;
}

- (NSArray *)loadMoments
{
    type = @"FINDALLMOMENT";
     NSError *error = nil;
     [socket connectToHost:@"192.168.1.118" onPort:8080 withTimeout:10 error:&error];
    if (moments.count == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FINDALLMOMENT_result" ofType:@"txt"];
        NSString *json = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
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

- (void)loadCountry
{
    [country removeAllObjects];
    NSError *error = nil;
    type = @"COUNTRY";
    [socket connectToHost:@"192.168.1.118" onPort:8080 withTimeout:10 error:&error];
}

/*
 >>> AsyncSocketDelegate >>>
 */
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Connected!");
    NSString *json;
    if([@"FINDALLMOMENT" isEqualToString:type]) {
        json = @"{\"type\":\"FINDALLMOMENT\",\"object\":\"9\",\"toUser\":0,\"fromUser\":0}\r\n";
    }else if([@"COUNTRY" isEqualToString:type]) {
         json = @"{\"type\":\"COUNTRY\",\"object\":\"en\",\"toUser\":0,\"fromUser\":0}\r\n";
    }
    
    NSLog(@"%@", json);
    [socket writeData:[json dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:1];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
     if([@"FINDALLMOMENT" isEqualToString:type]) {
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS MOMENTINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT,num INTEGER, data TEXT)";
    [self execSql:sqlCreateTable];
    NSError *error = nil;
   
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    BOOL isPerfix = [str hasPrefix:@"{\"type\":"];
    if(isPerfix) {
        NSString *sql =
        @"DELETE FROM MOMENTINFO";
        [self execSql:sql];

    }
    
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
                      TABLENAME, NUM, DATA,  @"1", str ];
    
 
    [self execSql:sql1];
    
    BOOL isSuffix = [str hasSuffix:@"\"}\r\n"];
    NSLog(@"%hhd", isSuffix);
    if (isSuffix) {
  
        NSString *sqlQuery = @"SELECT * FROM MOMENTINFO WHERE NUM = 1";
        sqlite3_stmt * statement;
        
        NSString *content = @"";
    
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(statement, 2);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            content = [content stringByAppendingString: nsNameStr];
        }
    }
    sqlite3_close(db);
     NSData *data1 = [content dataUsingEncoding:NSUTF8StringEncoding];
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data1
                                                       options:NSJSONReadingAllowFragments
                                                          error:&error];

    NSLog(@"%ld %@ %@", tag, dic, error);
    }
         
          if([@"COUNTRY" isEqualToString:type]) {
              NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&error];
              NSString *str = [dic objectForKey:@"object"];
              NSData *data1 = [str dataUsingEncoding:NSUTF8StringEncoding];
              //NSLog(@"%@", str);
              NSArray *arr = [NSJSONSerialization JSONObjectWithData:data1
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
              [country addObjectsFromArray:arr];

              NSLog(@"%ld %@ %@", tag, dic, error);
              

          }
    }
    
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

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
}

/*
 <<< AsyncSocketDelegate <<<
 */

@end

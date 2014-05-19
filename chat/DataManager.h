//
//  DataManager.h
//  chat
//
//  Created by Kenny on 2014/04/14.
//
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import "AsyncSocket.h"

#import "SIAlertView.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"
//#import "AppDelegate.h"

#define USER @"user"
#define NAME @"name"
#define CONTEXT @"context"
#define CREATE_TIME @"createTime"
#define LIKE_CNT @"likeCnt"
#define PRODUCT_NAME @"productName"
#define LIKE_NUM @"likeNum"
#define TAG_CNT @"tagCnt"
#define COMMENT_CNT @"CommentCnt"

#define ID @"id"
#define COUNTRYCODE @"country_code"
#define COUNTRYNAME @"country_name"
#define LANGUAGETYPE @"language_type"
#define SHORTNAME @"short_name"
#define DBNAME    @"most.sqlite"

#define NUM       @"num"
#define DATA   @"data"
#define MOMENTINFO @"MOMENTINFO"
#define COUNTRYINFO @"COUNTRYINFO"

@interface DataManager : NSObject <AsyncSocketDelegate>
{
    NSMutableArray *moments;
    NSMutableArray *things;
    AsyncSocket *socket;
    NSMutableArray *country;
    NSString *type;
    NSUserDefaults *defaults;
}


@property (nonatomic, strong) NSMutableArray *moments;
@property (nonatomic, strong) NSMutableArray *things;
@property (nonatomic, strong) NSMutableArray *country;
@property (nonatomic, strong)  NSString *type;
@property (nonatomic, strong)  AsyncSocket *socket;
@property (nonatomic, strong)  NSUserDefaults *defaults;

+ (DataManager *)sharedDataManager;
+ (UIImage *) imageWithColor:(UIColor*)color size:(CGSize)size;
+ (UIImage *)resize:(UIImage *)image rect:(CGRect)rect;

- (NSArray *)loadMoments;
- (NSArray *)loadThings;
- (void)loadCountry;
- (void) showDialog:(NSString *)dialogType content:(NSString*)content;
- (NSString *)md5:(NSString *)str;
- (NSArray *)getLoggedUser;
- (NSUserDefaults *)getDefaults;
- (NSString *)toJSONData:(id)theData;



@end

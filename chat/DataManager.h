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
#import <sqlite3.h>

#define USER @"user"
#define NAME @"name"
#define CONTEXT @"context"
#define CREATE_TIME @"createTime"
#define LIKE_CNT @"likeCnt"
#define PRODUCT_NAME @"productName"
#define LIKE_NUM @"likeNum"
#define TAG_CNT @"tagCnt"
#define COMMENT_CNT @"CommentCnt"

@interface DataManager : NSObject <AsyncSocketDelegate>
{
    NSMutableArray *moments;
    NSMutableArray *things;
    AsyncSocket *socket;
    sqlite3 *db;  
}

@property (nonatomic, strong) NSMutableArray *moments;
@property (nonatomic, strong) NSMutableArray *things;

+ (DataManager *)sharedDataManager;
+ (UIImage *) imageWithColor:(UIColor*)color size:(CGSize)size;
+ (UIImage *)resize:(UIImage *)image rect:(CGRect)rect;

- (NSArray *)loadMoments;
- (NSArray *)loadThings;

@end

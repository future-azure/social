//
//  RecentMessageDB.h
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import <Foundation/Foundation.h>
#import "sqlLite.h"

@interface RecentMessageDB : NSObject {
    sqlite3 *db;
    sqlLite *database;
}
+ (RecentMessageDB *) initUserDB;
- (void) saveMsg:(int)userId friend:(int)friendId entity:(NSDictionary *)entity;
- (NSArray *) getMsg:(int)userId;
- (void) clearMsg:(int)userId friend:(int)friendId;
- (void) clearAllMsg:(int)userId;
- (void) updateMsgNum:(int)userId friend:(int)friendId;
@end

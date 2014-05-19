//
//  MessageDB.h
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import <Foundation/Foundation.h>
#import "sqlLite.h"

@interface MessageDB : NSObject {
    sqlite3 *db;
    sqlLite *database;
}
+ (MessageDB *) initUserDB;
- (void) saveMsg:(int)userId friend:(int)friendId entity:(NSDictionary *)entity;
- (NSArray *) getMsg:(int)userId friend:(int)friendId;
- (void) clearMsg:(int)userId friend:(int)friendId;
- (void) clearAllMsg:(int)userId;
@end

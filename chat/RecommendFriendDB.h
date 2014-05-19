//
//  RecommendFriendDB.h
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import <Foundation/Foundation.h>
#import "sqlLite.h"

@interface RecommendFriendDB : NSObject {
    sqlite3 *db;
    sqlLite *database;
}
+ (RecommendFriendDB *) initUserDB;
- (NSMutableDictionary *) selectInfo:(int)id1 userId:(int)userId;
- (void) addUserList:(NSArray *)userList user:(NSDictionary*)user userId:(int)userId;
- (void) addUser: (NSDictionary *)u  user:(NSDictionary*)user  userId:(int)userId;
- (void) updateUserList:(NSArray *)userList user:(NSDictionary*)user userId:(int)userId;
- (void) updateUser: (NSDictionary *)user userId:(int)userId;
- (void) updateUserView: (NSDictionary *)user userId:(int)userId;
- (void) updateUser: (NSDictionary *)u user:(NSDictionary*)user userId:(int)userId;

- (NSMutableDictionary *) getUser:(NSDictionary *)user userId:(int)userId;
- (void) deleteAll:(NSDictionary *)user userId:(int)userId;
- (void) delete:(int)fId id1:(int)id1 userId:(int)userId;
@end


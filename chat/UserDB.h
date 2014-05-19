//
//  UserDB.h
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import <Foundation/Foundation.h>
#import "sqlLite.h"

@interface UserDB : NSObject {
    sqlite3 *db;
    sqlLite *database;
}
+ (UserDB *) initUserDB;

- (NSMutableDictionary *) selectInfo:(int)id1 userId:(int)userId;
- (void) addUserList:(NSArray *)userList userId:(int)userId;
- (void) addUser: (NSDictionary *)user userId:(int)userId;
- (void) updateUserList:(NSArray *)userList userId:(int)userId;
- (void) updateUser: (NSDictionary *)user userId:(int)userId;
- (NSArray *) getUser:(int)userId;
- (void) deleteAll:(int)userId;
- (void) delete:(int)id1 userId:(int)userId;

@end

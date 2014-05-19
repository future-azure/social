//
//  LoginUserDB.h
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import <Foundation/Foundation.h>

#import "sqlLite.h"

@interface LoginUserDB : NSObject {
    sqlite3 *db;
    sqlLite *database;
}
+ (LoginUserDB *) initUserDB;
- (void) addUser: (NSDictionary *)user password:(NSString *)password;
- (void) updateUser: (NSDictionary *)user password:(NSString *)password;
- (NSArray *) getUser;
- (void) delete:(NSDictionary *)user;
@end

//
//  SettingDB.h
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import <Foundation/Foundation.h>
#import "sqlLite.h"

@interface SettingDB : NSObject {
    sqlite3 *db;
    sqlLite *database;
}
+ (SettingDB *) initUserDB;
- (NSMutableDictionary *) getUserSetting:(int)userId;
- (void) saveSetting:(int)userId userSetting:(NSDictionary *)userSetting;

@end

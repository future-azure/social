//
//  RecommendFriendDB.m
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import "RecommendFriendDB.h"

@implementation RecommendFriendDB

+ (RecommendFriendDB *) initUserDB {
    static RecommendFriendDB *sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataManager = [[self alloc] init];
    });
    return sharedDataManager;
    
}

- (id)init
{
    if (self = [super init]) {
        database =[sqlLite initDataBase];
        db = [database getDB];
    }
    return self;
}
- (NSMutableDictionary *) selectInfo:(int)id1 userId:(int)userId{
    NSString *sql = @"CREATE table IF NOT EXISTS recommend_friend_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, friend_id INTEGER PRIMARY KEY, friend_request_delete INTEGER, friend_type INTEGER, request_view INTEGER);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM recommend_friend_'%d' WHERE id= '%d'", userId, id1];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSNumber *ids = [NSNumber numberWithInt: sqlite3_column_int(statement, 1)];
            NSNumber *friendType = [NSNumber numberWithInt: sqlite3_column_int(statement, 3)];
            NSNumber *requestDelete = [NSNumber numberWithInt: sqlite3_column_int(statement, 2)];
            NSNumber *requestView = [NSNumber numberWithInt: sqlite3_column_int(statement, 4)];
            NSArray  *keys= [NSArray arrayWithObjects:@"id", @"friendType", @"requestDelete", @"requestView", nil];
            NSArray *objects= [NSArray arrayWithObjects:ids, friendType, requestDelete, requestView,nil];
            
            NSMutableDictionary *user = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
            return user;
            
        }
    }
    //  sqlite3_close(db);
    
    
    
    return nil;
}
- (void) addUserList:(NSArray *)userList user:(NSDictionary*)user userId:(int)userId{
    NSString *sql = @"CREATE table IF NOT EXISTS recommend_friend_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, friend_id INTEGER PRIMARY KEY, friend_request_delete INTEGER, friend_type INTEGER, request_view INTEGER);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    for(id obj in userList)
    {
        NSMutableDictionary *cDic = obj;
        sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO recommend_friend_'%d' VALUES ('%@','%@','%@','%@','%@');", userId, [user objectForKey:@"id"],[cDic objectForKey:@"id"],[cDic objectForKey:@"friendType"],[cDic objectForKey:@"friendRequest"],[cDic objectForKey:@"requestView"]];
        [database execSql:sql];
    }
    
}
- (void) addUser: (NSDictionary *)u  user:(NSDictionary*)user  userId:(int)userId{
    
    NSString *sql = @"CREATE table IF NOT EXISTS recommend_friend_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, friend_id INTEGER PRIMARY KEY, friend_request_delete INTEGER, friend_type INTEGER, request_view INTEGER);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    
    
    sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO recommend_friend_'%d' VALUES ('%@','%@','%@','%@','%@');", userId, [user objectForKey:@"id"],[u objectForKey:@"id"],[u objectForKey:@"friendType"],[u objectForKey:@"friendRequest"],[u objectForKey:@"requestView"]];
    [database execSql:sql];
    
    
    
}
- (void) updateUserList:(NSArray *)userList user:(NSDictionary*)user userId:(int)userId{
    if (userList.count > 0) {
        [self deleteAll:user userId:userId];
        [self addUserList:userList user:user userId:userId];
    }
    
}
- (void) updateUser:(NSDictionary *)user userId:(int)userId {
    NSString *sql = @"CREATE table IF NOT EXISTS recommend_friend_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, friend_id INTEGER PRIMARY KEY, friend_request_delete INTEGER, friend_type INTEGER, request_view INTEGER);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"update recommend_friend_'%d' set friend_request_delete = 1 where id = '%@'", userId, [user objectForKey:@"id"]];
    [database execSql:sql];
}

- (void) updateUserView:(NSDictionary *)user userId:(int)userId  {
    NSString *sql = @"CREATE table IF NOT EXISTS recommend_friend_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, friend_id INTEGER PRIMARY KEY, friend_request_delete INTEGER, friend_type INTEGER, request_view INTEGER);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"update recommend_friend_'%d' set request_view = 1 where id = '%@'", userId, [user objectForKey:@"id"]];
    [database execSql:sql];
}

- (void) updateUser:(NSDictionary *)u user:(NSDictionary*)user userId:(int)userId{
    int intString = [[user objectForKey:@"id"] intValue];
    int intString2 = [[u objectForKey:@"id"] intValue];
    [self delete:intString2 id1:intString userId:userId];
    [self addUser:u user:user userId:userId];
    
}

- (NSMutableDictionary *) getUser:(NSDictionary *)user userId:(int)userId{
    NSString *sql = @"CREATE table IF NOT EXISTS recommend_friend_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, friend_id INTEGER PRIMARY KEY, friend_request_delete INTEGER, friend_type INTEGER, request_view INTEGER);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    
    NSMutableDictionary *userList = [NSMutableDictionary dictionaryWithCapacity:5];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"select * from recommend_friend_'%d' where id='%@'",userId, [user objectForKey:@"id"]];
    
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSNumber *ids = [NSNumber numberWithInt: sqlite3_column_int(statement, 1)];
            NSNumber *friendType = [NSNumber numberWithInt: sqlite3_column_int(statement, 3)];
            NSNumber *requestDelete = [NSNumber numberWithInt: sqlite3_column_int(statement, 2)];
            NSNumber *requestView = [NSNumber numberWithInt: sqlite3_column_int(statement, 4)];
            NSArray  *keys= [NSArray arrayWithObjects:@"id", @"friendType", @"requestDelete", @"requestView", nil];
            NSArray *objects= [NSArray arrayWithObjects:ids, friendType, requestDelete, requestView,nil];
            
            NSMutableDictionary *user = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
            [userList setObject:user forKey:ids];
        }
    }
    return userList;
}
- (void) deleteAll:(NSDictionary *)user userId:(int)userId {
    NSString *sql = @"CREATE table IF NOT EXISTS recommend_friend_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, friend_id INTEGER PRIMARY KEY, friend_request_delete INTEGER, friend_type INTEGER, request_view INTEGER);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"delete from recommend_friend_'%d' where id = '%@'", userId, [user objectForKey:@"id"]];
    [database execSql:sqlQuery];
    
}
- (void) delete:(int)fId id1:(int)id1 userId:(int)userId {
    NSString *sql = @"CREATE table IF NOT EXISTS recommend_friend_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, friend_id INTEGER PRIMARY KEY, friend_request_delete INTEGER, friend_type INTEGER, request_view INTEGER);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"delete from recommend_friend_'%d' where id = '%d' and friend_id = '%d'", userId, id1, fId];
    [database execSql:sqlQuery];
    
}


@end
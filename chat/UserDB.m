//
//  UserDB.m
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import "UserDB.h"

@implementation UserDB


+ (UserDB *) initUserDB {
    static UserDB *sharedDataManager = nil;
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
    NSString *sql = @"CREATE TABLE IF NOT EXISTS user_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, img TEXT, imgPath TEXT, isOnline TEXT, _group TEXT);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    

    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM user_'%d' WHERE id= '%d'", userId, id1];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    
                                         char *img = (char*)sqlite3_column_text(statement, 2);
                       NSString *imgString = [[NSString alloc]initWithUTF8String:img];
                       char *imgPath =(char*)sqlite3_column_text(statement, 3);
                        NSString *imgPathString = [[NSString alloc]initWithUTF8String:imgPath];
                    char *name =(char*)sqlite3_column_text(statement, 1);
                    NSString *nameString = [[NSString alloc]initWithUTF8String:name];
                     NSNumber *ids = [NSNumber numberWithInt: sqlite3_column_int(statement, 0)];
                    NSArray  *keys= [NSArray arrayWithObjects:@"id", @"imgId", @"img", @"name", nil];
                    NSArray *objects= [NSArray arrayWithObjects:ids, imgString, imgPathString, nameString,nil];
                    
                    NSMutableDictionary *user = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
                    return user;
                    
                    }
               }
  //  sqlite3_close(db);

    

    return nil;
}
- (void) addUserList:(NSArray *)userList userId:(int)userId{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS user_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, img TEXT, imgPath TEXT, isOnline TEXT, _group TEXT);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    for(id obj in userList)
    {
        NSMutableDictionary *cDic = obj;
        sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO user_'%d' VALUES ('%@','%@','%@','%@','%@','%@');", userId, [cDic objectForKey:@"id"],[cDic objectForKey:@"name"], [cDic objectForKey:@"imgId"],[cDic objectForKey:@"img"],[cDic objectForKey:@"isOnline"],[cDic objectForKey:@"group"]];
        [database execSql:sql];
    }
    
}
- (void) addUser: (NSDictionary *)user userId:(int)userId{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS user_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, img TEXT, imgPath TEXT, isOnline TEXT, _group TEXT);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
  
        sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO user_'%d' VALUES ('%@','%@','%@','%@','%@','%@');", userId, [user objectForKey:@"id"],[user objectForKey:@"name"], [user objectForKey:@"imgId"],[user objectForKey:@"img"],[user objectForKey:@"isOnline"],[user objectForKey:@"group"]];
        [database execSql:sql];
    

    
}
- (void) updateUserList:(NSArray *)userList userId:(int)userId{
    if (userList.count > 0) {
        [self deleteAll:userId];
        [self addUserList:userList userId:userId];
    }
    
}
- (void) updateUser: (NSDictionary *)user userId:(int)userId{
    int intString = [[user objectForKey:@"id"] intValue];

    [self delete:intString userId:userId];
    [self addUser:user userId:userId];
}
- (NSArray *) getUser:(int)userId{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS user_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, img TEXT, imgPath TEXT, isOnline TEXT, _group TEXT);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    NSMutableArray *userList = [[NSMutableArray alloc] init];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM user_'%d'", userId];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *img = (char*)sqlite3_column_text(statement, 2);
            NSString *imgString = [[NSString alloc]initWithUTF8String:img];
            char *imgPath =(char*)sqlite3_column_text(statement, 3);
            NSString *imgPathString = [[NSString alloc]initWithUTF8String:imgPath];
            char *name =(char*)sqlite3_column_text(statement, 1);
            NSString *nameString = [[NSString alloc]initWithUTF8String:name];
            NSNumber *ids = [NSNumber numberWithInt: sqlite3_column_int(statement, 0)];
            char *isOnline =(char*)sqlite3_column_text(statement, 4);
            NSString *isOnlineString = [[NSString alloc]initWithUTF8String:isOnline];
            char *group =(char*)sqlite3_column_text(statement, 5);
            NSString *groupString = [[NSString alloc]initWithUTF8String:group];
            NSArray  *keys= [NSArray arrayWithObjects:@"id", @"imgId", @"img", @"name", @"isOnline", @"group", nil];
            NSArray *objects= [NSArray arrayWithObjects:ids, imgString, imgPathString, nameString,isOnlineString, groupString, nil];
            
            NSMutableDictionary *user = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
            [userList addObject:user];
            
        }
    }
    return userList;
}
- (void) deleteAll:(int)userId{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS user_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, img TEXT, imgPath TEXT, isOnline TEXT, _group TEXT);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    NSString *sqlQuery = [NSString stringWithFormat:@"DELETE FROM user_'%d'", userId];
    [database execSql:sqlQuery];

}
- (void) delete:(int)id1 userId:(int)userId{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS user_";
    NSString *sql1 = @" (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, img TEXT, imgPath TEXT, isOnline TEXT, _group TEXT);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    NSString *sqlQuery = [NSString stringWithFormat:@"DELETE FROM user_'%d' where id = '%d'", userId, id1];
    [database execSql:sqlQuery];
    
}
@end

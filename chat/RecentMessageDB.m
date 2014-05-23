//
//  RecentMessageDB.m
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import "RecentMessageDB.h"

@implementation RecentMessageDB

+ (RecentMessageDB *) initUserDB {
    static RecentMessageDB *sharedDataManager = nil;
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

- (void) saveMsg:(int)userId friend:(int)friendId entity:(NSDictionary *)entity{
    NSString *sql = @"CREATE table IF NOT EXISTS recent_msg_";
    NSString *sql1 = @"(_id INTEGER PRIMARY KEY,name TEXT, img TEXT, imgPath TEXT, date TEXT, message TEXT, count INTEGER)";
    sql = [sql stringByAppendingFormat:@"%d%@",userId,sql1];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS unique_index_id ON recent_msg_%d (_id);", userId];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"INSERT OR REPLACE into  recent_msg_%d (_id,name,img, imgPath, date,message, count) values('%d','%@','%@','%@','%@','%@', '%@');", userId, friendId, [entity objectForKey:@"name"],[entity objectForKey:@"img"], [entity objectForKey:@"imgPath"],[entity objectForKey:@"time"],[entity objectForKey:@"msg"],[entity objectForKey:@"count"]];
    [database execSql:sql];
    
}

- (void) updateMsgNum:(int)userId friend:(int)friendId{
    NSString *sql = @"CREATE table IF NOT EXISTS recent_msg_";
    NSString *sql1 = @"(_id INTEGER PRIMARY KEY,name TEXT, img TEXT, imgPath TEXT, date TEXT, message TEXT, count INTEGER)";
    sql = [sql stringByAppendingFormat:@"%d%@",userId,sql1];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS unique_index_id ON recent_msg_%d (_id);", userId];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"update recent_msg_%d set count = 0 where _id = '%d';", userId, friendId];
    [database execSql:sql];
    
    
}

- (NSArray *) getMsg:(int)userId {
    NSString *sql = @"CREATE table IF NOT EXISTS recent_msg_";
    NSString *sql1 = @"(_id INTEGER PRIMARY KEY,name TEXT, img TEXT, imgPath TEXT, date TEXT, message TEXT, count INTEGER)";
    sql = [sql stringByAppendingFormat:@"%d%@",userId,sql1];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS unique_index_id ON recent_msg_%d (_id);", userId];
    [database execSql:sql];

    
    NSMutableArray *msgList = [[NSMutableArray alloc] init];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * from recent_msg_%d ORDER BY _id DESC", userId];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
    
            char *imgPath =(char*)sqlite3_column_text(statement, 3);
            NSString *imgPathString = [[NSString alloc]initWithUTF8String:imgPath];
            
            char *name =(char*)sqlite3_column_text(statement, 1);
            NSString *nameString = [[NSString alloc]initWithUTF8String:name];
            
            NSNumber *img = [NSNumber numberWithInt: sqlite3_column_int(statement, 2)];
            NSNumber *ids = [NSNumber numberWithInt: sqlite3_column_int(statement, 0)];
            NSNumber *count = [NSNumber numberWithInt: sqlite3_column_int(statement, 6)];
            
            
            char *date =(char*)sqlite3_column_text(statement, 4);
            NSString *dateString = [[NSString alloc]initWithUTF8String:date];
            
            char *message =(char*)sqlite3_column_text(statement, 5);
            NSString *messageString = [[NSString alloc]initWithUTF8String:message];
            
            NSArray  *keys= [NSArray arrayWithObjects: @"id", @"imgPath", @"name", @"time", @"msg", @"count", @"img", nil];
            NSArray *objects= [NSArray arrayWithObjects:ids, imgPathString, nameString, dateString, messageString, count, img, nil];
            
            NSMutableDictionary *user = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
            [msgList addObject:user];
            
        }
    }
    return msgList;
}

- (void) clearMsg:(int)userId friend:(int)friendId {
    NSString *sql = @"CREATE table IF NOT EXISTS recent_msg_";
    NSString *sql1 = @"(_id INTEGER PRIMARY KEY,name TEXT, img TEXT, imgPath TEXT, date TEXT, message TEXT, count INTEGER)";
    sql = [sql stringByAppendingFormat:@"%d%@",userId,sql1];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS unique_index_id ON recent_msg_%d (_id);", userId];
    [database execSql:sql];
    
    
    sql =[NSString stringWithFormat:@"DELETE FROM recent_msg_%d where _id = '%d'", userId, friendId];
    [database execSql:sql];
    
}
- (void) clearAllMsg:(int)userId {
    NSString *sql = @"CREATE table IF NOT EXISTS recent_msg_";
    NSString *sql1 = @"(_id INTEGER PRIMARY KEY,name TEXT, img TEXT, imgPath TEXT, date TEXT, message TEXT, count INTEGER)";
    sql = [sql stringByAppendingFormat:@"%d%@",userId,sql1];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS unique_index_id ON recent_msg_%d (_id);", userId];
    [database execSql:sql];
    
    
    sql =[NSString stringWithFormat:@"DELETE FROM recent_msg_%d", userId];
    [database execSql:sql];
}

@end

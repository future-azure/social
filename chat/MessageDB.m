//
//  MessageDB.m
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import "MessageDB.h"

@implementation MessageDB

+ (MessageDB *) initUserDB {
    static MessageDB *sharedDataManager = nil;
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
    NSString *sql = @"CREATE TABLE IF NOT EXISTS msg_";
    NSString *sql1 = @" (_id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, img INTEGER, imgPath TEXT, date TEXT,isCome INTEGER,message TEXT)";
    sql = [sql stringByAppendingFormat:@"%d%@%d%@",userId, @"_", friendId,sql1];
    [database execSql:sql];
    
    bool isCome = [entity objectForKey:@"msgType"];
    int come = 0;
    if (isCome) {
        come = 1;
    }
    
    sql = [NSString stringWithFormat:@"insert into  msg_%d_%d  (name,img, imgPath, date,isCome,message)  VALUES ('%@','%@','%@','%@','%d','%@');", userId, friendId, [entity objectForKey:@"name"],[entity objectForKey:@"img"], [entity objectForKey:@"imgPath"],[entity objectForKey:@"date"],come,[entity objectForKey:@"message"]];
    [database execSql:sql];
    
}

- (NSArray *) getMsg:(int)userId friend:(int)friendId{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS msg_";
    NSString *sql1 = @" (_id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, img INTEGER, imgPath TEXT, date TEXT,isCome INTEGER,message TEXT)";
    sql = [sql stringByAppendingFormat:@"%d%@%d%@",userId, @"_", friendId,sql1];
    [database execSql:sql];
    
    NSMutableArray *msgList = [[NSMutableArray alloc] init];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * from msg_%d_%d ORDER BY _id DESC", userId, friendId];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
           
            char *imgPath =(char*)sqlite3_column_text(statement, 3);
            NSString *imgPathString = [[NSString alloc]initWithUTF8String:imgPath];
            
            char *name =(char*)sqlite3_column_text(statement, 1);
            NSString *nameString = [[NSString alloc]initWithUTF8String:name];
            
            NSNumber *img = [NSNumber numberWithInt: sqlite3_column_int(statement, 2)];
            int isCome = sqlite3_column_int(statement, 5);
            bool come = false;
            if(isCome == 1) {
                come = true;
            }
            
            char *date =(char*)sqlite3_column_text(statement, 4);
            NSString *dateString = [[NSString alloc]initWithUTF8String:date];
            
            char *message =(char*)sqlite3_column_text(statement, 6);
            NSString *messageString = [[NSString alloc]initWithUTF8String:message];
            
            NSArray  *keys= [NSArray arrayWithObjects: @"img", @"imgPath", @"name", @"date", @"message", @"msgType", nil];
            NSArray *objects= [NSArray arrayWithObjects:img, imgPathString, nameString, dateString, messageString, come, nil];
            
            NSMutableDictionary *user = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
            [msgList addObject:user];
            
        }
    }
    return msgList;
}

- (void) clearMsg:(int)userId friend:(int)friendId {
    NSString *sql =[NSString stringWithFormat:@"DROP TABLE IF EXISTS msg_%d_%d", userId, friendId];
      [database execSql:sql];

}
- (void) clearAllMsg:(int)userId {
    NSString *sqlQuery =@"select name from sqlite_master where type='table' order by name";
    sqlite3_stmt * statement;
    NSMutableArray *tables = [[NSMutableArray alloc] initWithCapacity:5];
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name =(char*)sqlite3_column_text(statement, 0);
            NSString *tableName = [[NSString alloc]initWithUTF8String:name];
           
            NSString *msg = [NSString stringWithFormat:@"msg_%d_", userId];

            NSRange foundObj=[tableName rangeOfString:msg options:NSCaseInsensitiveSearch];
            if(foundObj.length>0) {
                [tables addObject:tableName];
              
            } 
            
        }
    }
    for (NSString *name in tables) {
        NSString *sql =[NSString stringWithFormat:@"DROP TABLE IF EXISTS '%@';", name];
        [database execSql:sql];
    }

}

@end


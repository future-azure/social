//
//  SettingDB.m
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import "SettingDB.h"

@implementation SettingDB

+ (SettingDB *) initUserDB {
    static SettingDB *sharedDataManager = nil;
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
- (NSMutableDictionary *) getUserSetting:(int)userId{
    NSString *sql = @"CREATE table IF NOT EXISTS user_setting_";
    NSString *sql1 = @" (_id INTEGER PRIMARY KEY AUTOINCREMENT, enterSend INTEGER, fontSize INTEGER,  language TEXT, chatBg INTEGER, alert INTEGER, sound INTEGER, soundName TEXT, vibe INTEGER, whole_day INTEGER, begin_time TIMESTAMP, end_time TIMESTAMP, offer INTEGER);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS unique_index_id ON user_setting_%d (_id);",userId];
    [database execSql:sql];
    
    NSArray  *keys= [NSArray arrayWithObjects:@"chatBg", @"enterSend", @"fontSize", @"language",@"alert",@"sound",@"soundName", @"vibe", @"whole_day", @"begin_time",@"end_time", @"offer",nil];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //this is the sqlite's format

    NSArray *objects= [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:0], [NSNumber numberWithInt:18], @"en",[NSNumber numberWithInt:1],[NSNumber numberWithInt:0], @"", [NSNumber numberWithInt:0], [NSNumber numberWithInt:1],  [formatter stringFromDate:[NSDate date]],  [formatter stringFromDate:[NSDate date]], [NSNumber numberWithInt:0],nil];
    
    NSMutableDictionary *user = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];

    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT *,datetime(begin_time,'localtime'), datetime(end_time,'localtime') FROM user_setting_%d ORDER BY _id DESC LIMIT 1", userId];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSNumber *chatBg = [NSNumber numberWithInt: sqlite3_column_int(statement, 4)];
            NSNumber *enterSend = [NSNumber numberWithInt: sqlite3_column_int(statement, 1)];
            NSNumber *fontSize = [NSNumber numberWithInt: sqlite3_column_int(statement, 2)];
            NSNumber *whole_day = [NSNumber numberWithInt: sqlite3_column_int(statement, 9)];
            NSNumber *alert = [NSNumber numberWithInt: sqlite3_column_int(statement, 5)];
            NSNumber *sound = [NSNumber numberWithInt: sqlite3_column_int(statement, 6)];
            NSNumber *vibe = [NSNumber numberWithInt: sqlite3_column_int(statement, 8)];
            NSNumber *offer = [NSNumber numberWithInt: sqlite3_column_int(statement, 12)];
            
            
            char *language = (char*)sqlite3_column_text(statement, 3);
            NSString *languageString = [[NSString alloc]initWithUTF8String:language];
            char *soundName =(char*)sqlite3_column_text(statement, 7);
            NSString *soundNameString = [[NSString alloc]initWithUTF8String:soundName];
            //NSLog(@"%@", statement);
            char *bt =(char*)sqlite3_column_text(statement, 10);
            NSString *btString = [[NSString alloc]initWithUTF8String:bt];
            char *et =(char*)sqlite3_column_text(statement, 11);
            NSString *etString = [[NSString alloc]initWithUTF8String:et];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //this is the sqlite's format
      //      NSDate *begin_time = [formatter dateFromString:btString];
       //     NSDate *end_time = [formatter dateFromString:etString];
           
            [user setObject:chatBg forKey:@"chatBg"];
            [user setObject:enterSend forKey:@"enterSend"];
            [user setObject:fontSize forKey:@"fontSize"];
            [user setObject:languageString forKey:@"language"];
            [user setObject:alert forKey:@"alert"];
            [user setObject:sound forKey:@"sound"];
            [user setObject:soundNameString forKey:@"soundName"];
            [user setObject:vibe forKey:@"vibe"];
            [user setObject:whole_day forKey:@"whole_day"];
            [user setObject:btString forKey:@"begin_time"];
            [user setObject:etString forKey:@"end_time"];
            [user setObject:offer forKey:@"offer"];
        }
    }
    
    return user;
}

- (void) saveSetting:(int)userId userSetting:(NSDictionary *)userSetting{
    NSString *sql = @"CREATE table IF NOT EXISTS user_setting_";
    NSString *sql1 = @" (_id INTEGER PRIMARY KEY AUTOINCREMENT, enterSend INTEGER, fontSize INTEGER,  language TEXT, chatBg INTEGER, alert INTEGER, sound INTEGER, soundName TEXT, vibe INTEGER, whole_day INTEGER, begin_time TIMESTAMP, end_time TIMESTAMP, offer INTEGER);";
    sql = [sql stringByAppendingFormat:@"%d%@",userId, sql1];
    [database execSql:sql];
    
    sql = [NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS unique_index_id ON user_setting_%d (_id);",userId];
    [database execSql:sql];
    
    
    sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO user_setting_%d (_id, enterSend, fontSize, language, chatBg,  alert, sound, soundName, vibe, whole_day, begin_time, end_time, offer) values(1,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');", userId, [userSetting objectForKey:@"enterSend"],[userSetting objectForKey:@"fontSize"], [userSetting objectForKey:@"language"],[userSetting objectForKey:@"chatBg"],[userSetting objectForKey:@"alert"],[userSetting objectForKey:@"sound"], [userSetting objectForKey:@"soundName"],[userSetting objectForKey:@"vibe"], [userSetting objectForKey:@"whole_day"],[userSetting objectForKey:@"begin_time"],[userSetting objectForKey:@"end_time"],[userSetting objectForKey:@"offer"]];
    [database execSql:sql];
    
}

@end



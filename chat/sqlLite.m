//
//  sqlLite.m
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import "sqlLite.h"

@implementation sqlLite

+ (sqlLite *) initDataBase {
    static sqlLite *sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataManager = [[self alloc] init];
    });
    return sharedDataManager;
    
}

- (id)init
{
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
        
        if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
        }
        NSString *sql = @"CREATE table IF NOT EXISTS login_user (id INTEGER PRIMARY KEY AUTOINCREMENT, password TEXT, name TEXT, imgId INTEGER, imgPath TEXT);";
        [self execSql:sql];
        sql = @"CREATE TABLE IF NOT EXISTS launcher(id INTEGER PRIMARY KEY AUTOINCREMENT,photo BINARY);";
        [self execSql:sql];
        
        //sql = @"DROP TABLE IF EXISTS user_setting_8";
        //[self execSql:sql];


    }
    return self;
}

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"sql: %@", sql);
        sqlite3_close(db);
        NSLog(@"error: %s", err);
        NSLog(@"数据库操作数据失败!");
    }
}

-(sqlite3 *)getDB {
    return db;
}

@end

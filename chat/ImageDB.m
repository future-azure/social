//
//  ImageDB.m
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import "ImageDB.h"

@implementation ImageDB

+ (ImageDB *) initDB {
    static ImageDB *sharedDataManager = nil;
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
- (void) addImage: (int)userId bm:(UIImage *)bm     {
    NSData *data = UIImageJPEGRepresentation(bm, 1.0);
//    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO launcher VALUES ('%d','%@');",userId, data];
    const char* sqliteQuery = "INSERT OR REPLACE INTO launcher VALUES (?, ?)";
    sqlite3_stmt* statement;
    
    if( sqlite3_prepare_v2(db, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
    {
        sqlite3_bind_int(statement, 1, userId);
        sqlite3_bind_blob(statement, 2, [data bytes], [data length], SQLITE_TRANSIENT);
        sqlite3_step(statement);
    }
    else NSLog( @"SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) );
    
    // Finalize and close database.
    sqlite3_finalize(statement);
  //  [database execSql:sql];
    
}

- (UIImage *) getImage: (int)iId {
    NSData* data = nil;
    UIImage *aimage ;
    NSString* sqliteQuery = [NSString stringWithFormat:@"SELECT IMAGE FROM launcher WHERE id = '%d'", iId];
    sqlite3_stmt* statement;
    
    if( sqlite3_prepare_v2(db, [sqliteQuery UTF8String], -1, &statement, NULL) == SQLITE_OK )
    {
        if( sqlite3_step(statement) == SQLITE_ROW )
        {
            int length = sqlite3_column_bytes(statement, 0);
            data = [NSData dataWithBytes:sqlite3_column_blob(statement, 0) length:length];
            aimage =[UIImage imageWithData: data];
        }
    }
    
    // Finalize and close database.
    sqlite3_finalize(statement);
    return aimage;
}

@end

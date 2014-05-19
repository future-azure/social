//
//  LoginUserDB.m
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import "LoginUserDB.h"

@implementation LoginUserDB

+ (LoginUserDB *) initUserDB {
    static LoginUserDB *sharedDataManager = nil;
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
- (void) addUser:  (NSDictionary *)user password:(NSString *)password{
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO login_user VALUES ('%@','%@','%@','%@','%@');",[user objectForKey:@"id"],password,[user objectForKey:@"name"], [user objectForKey:@"imgId"],[user objectForKey:@"img"]];
    [database execSql:sql];
    
}

- (void) updateUser: (NSDictionary *)user password:(NSString *)password{
    [self delete:user];
    [self addUser:user password:password];
}

- (NSArray *) getUser{
    NSMutableArray *userList = [[NSMutableArray alloc] init];
    
    NSString *sqlQuery = @"select * from login_user;";
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *img = (char*)sqlite3_column_text(statement, 3);
            NSString *imgString = [[NSString alloc]initWithUTF8String:img];
            char *imgPath =(char*)sqlite3_column_text(statement, 4);
            NSString *imgPathString = [[NSString alloc]initWithUTF8String:imgPath];
            char *name =(char*)sqlite3_column_text(statement, 2);
            NSString *nameString = [[NSString alloc]initWithUTF8String:name];
            NSNumber *ids = [NSNumber numberWithInt: sqlite3_column_int(statement, 0)];
            char *password =(char*)sqlite3_column_text(statement, 1);
            NSString *passwordString = [[NSString alloc]initWithUTF8String:password];
           
            NSArray  *keys= [NSArray arrayWithObjects:@"id", @"imgId", @"password", @"name", @"img",  nil];
            NSArray *objects= [NSArray arrayWithObjects:ids, imgString,passwordString, nameString,imgPathString, nil];
            
            NSMutableDictionary *user = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
            [userList addObject:user];
            
        }
    }
    return userList;
}

- (void) delete:(NSDictionary *)user {
    NSString *sqlQuery = [NSString stringWithFormat:@"DELETE FROM login_user where id = '%@'", [user objectForKey:@"id"]];
    [database execSql:sqlQuery];
    
}
@end


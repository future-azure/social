//
//  sqlLite.h
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DBNAME    @"most.sqlite"

@interface sqlLite : NSObject {
    sqlite3 *db;
}

+ (sqlLite *) initDataBase;
-(void)execSql:(NSString *)sql;
-(sqlite3 *)getDB;

@end

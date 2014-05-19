//
//  ImageDB.h
//  chat
//
//  Created by brightvision on 14-5-15.
//
//

#import <Foundation/Foundation.h>

#import "sqlLite.h"

@interface ImageDB : NSObject {
    sqlite3 *db;
    sqlLite *database;
}
+ (ImageDB *) initDB;
- (void) addImage: (int)userId bm:(UIImage *)bm;
- (UIImage *) getImage: (int)iId;

@end


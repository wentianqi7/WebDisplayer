//
//  DBManager.m
//  Epanes
//
//  Created by Tianqi Wen on 3/17/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent: @"projects.db"]];
    BOOL isSuccess = TRUE;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == FALSE) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            const char *sql_stmt = "create table if not exists projectHistory (rid integer primary key autoincrement, projID integer)";

            if (sqlite3_exec(database, sql_stmt, NULL, NULL, nil) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            
            NSLog(@"create table success");
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) saveHistoryData:(int) projID {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"delete from projectHistory where projID = %d", projID];
        const char *delete_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(database, delete_stmt, -1, &statement, NULL);
        sqlite3_step(statement);
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into projectHistory (projID) values (\"%d\")", projID];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, nil);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            return TRUE;
        } else {
            NSLog(@"save data failed");
            return FALSE;
        }
    }
    return FALSE;
}
                                
- (NSMutableArray*) getRecentHistory:(int)count {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select rid, projID from projectHistory order by rid desc limit \"%d\"", count];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *projID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSLog(@"read one record %@", projID);
                [resultArray addObject:projID];
            }
            return resultArray;
        }
    }
    
    return nil;
}

@end
